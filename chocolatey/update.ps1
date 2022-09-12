# Get latest release info
$releases_url = 'https://quarto.org/docs/download/_download.json'
$release_info = Invoke-WebRequest $releases_url | ConvertFrom-Json

$zip = $release_info.assets |  Where-Object {$_.name -Match "win.zip$"}

# Replace information in document

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

# Update nuspec

[xml]$xml = Get-Content -path $NuSpecFile -Raw
$ns = [System.Xml.XmlNamespaceManager]::new($xml.NameTable)

[version]$Version = [version]::parse($xml.SelectSingleNode('/nuspec:package/nuspec:metadata/nuspec:version', $ns).InnerText)
[version]$NewVersion = [version]::parse($release_info.version)

if ($NewVersion -le $Version) {
    Write-Host -ForegroundColor DarkBlue "No new version"
    Exit
}

$xml.SelectSingleNode('/nuspec:package/nuspec:metadata/nuspec:version', $ns).InnerText = $NewVersion.ToString()
$xml.SelectSingleNode('/nuspec:package/nuspec:metadata/nuspec:description', $ns).InnerText = $release_info.description

$xml.Save($NuSpecFile)

# Remove old zip and Download
Get-ChildItem "tools" | Where{$_.Name -Match ".*win[.]zip$"} | Remove-Item
Invoke-WebRequest -uri $zip.download_url -Method "GET"  -Outfile (Join-Path "tools" $zip.name) 


# Create choco package
choco pack

