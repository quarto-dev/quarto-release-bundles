# Get latest release info

function updateAndBuild() { 

    $res = @{}

    Write-Host "> Fetching new version information"
    $releases_url = 'https://quarto.org/docs/download/_download.json'
    $release_info = Invoke-WebRequest $releases_url | ConvertFrom-Json

    $zip = $release_info.assets |  Where-Object {$_.name -Match "win.zip$"}

    # Update nuspec file
    $NuSpecFile = Resolve-Path "quarto.nuspec"
    try
    {

        [xml]$xml = (Get-Content -path $NuSpecFile -Raw)
        $ns = [System.Xml.XmlNamespaceManager]::new($xml.NameTable)
        $ns.AddNamespace('nuspec', 'http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd')

        [version]$Version = [version]::parse($xml.SelectSingleNode('/nuspec:package/nuspec:metadata/nuspec:version', $ns).InnerText)
        [version]$NewVersion = [version]::parse($release_info.version)
        res.NewVersion = $NewVersion.ToString()

        Write-Host "> Current: $Version - New: $NewVersion"

        if ($NewVersion -le $Version) {
            Write-Host -ForegroundColor DarkBlue "  > No new version"
            $res.Updated = $false
        } else {
            Write-Host -ForegroundColor DarkBlue "  > New version found"
            $res.Updated = $true

            $xml.SelectSingleNode('/nuspec:package/nuspec:metadata/nuspec:version', $ns).InnerText = $NewVersion.ToString()
            $xml.SelectSingleNode('/nuspec:package/nuspec:metadata/nuspec:releaseNotes', $ns).InnerText = $release_info.description

            Write-Host "> Updating Nuspec file $NuSpecFile"
            $xml.Save("$NuSpecFile")
        }
    }
    catch
    {
        Write-Host -ForegroundColor DarkRed "   > Issue with writing XML"
        throw
    }

    if ($res.Updated) {

        # Replace information in document
        Write-Host "> Updating tools files"
        function SearchReplace {
            param (
                # Path to file to search and replace
                [string] $File, 
                # Pattern to search for
                [string] $Search, 
                # Pattern to replace
                [string] $Replace
            )
            (Get-Content $File) | % {$_ -replace $Search, $Replace } | Set-Content $File
        }

        SearchReplace ".\legal\VERIFICATION.txt" "(?i)(\s+bundle:).*" "`${1} $($zip.download_url)"
        SearchReplace ".\legal\VERIFICATION.txt" "(?i)(checksum:).*" "`${1} $($zip.checksum)"
    }


    # Remove old zip if any and download
    Write-Host "> Downloading bundle"
    Get-ChildItem "tools" | Where{$_.Name -Match ".*win[.]zip$"} | Remove-Item
    Invoke-WebRequest -uri $zip.download_url -Method "GET"  -Outfile (Join-Path "tools" $zip.name)


    # Create choco package
    Write-Host "> Creating nupkg file for version $NewVersion"
    choco pack -v


    return $res
}

updateAndBuild