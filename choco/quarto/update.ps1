import-module au

$releases = 'https://quarto.org/docs/download/_download.json'
function global:au_SearchReplace {
    @{
       ".\tools\VERIFICATION.txt" = @{
          "(?i)(\s+installer:).*"      = "`${1} $($Latest.URL64)"
          "(?i)(checksum:).*"          = "`${1} $($Latest.Checksum64)"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
     }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_GetLatest {
    $bundles = Invoke-WebRequest -Uri $releases | ConvertFrom-Json

    $msi = $bundles.assets |  Where-Object {$_.name -Match ".msi$"}

    $re      = 'dnGREP.*.msi'
    $url     = $msi.download_url
    $version = $msi.name -split '-' | select -Index 1

    return @{
        Version = $version
        URL64 = $msi.download_url
        Checksum64 = $msi.checksum
        ReleaseNotes = "https://github.com/quarto-dev/quarto-cli/releases/tag/v$version"
    }
}

function global:au_AfterUpdate ($Package)  {
    
}

update -ChecksumFor none