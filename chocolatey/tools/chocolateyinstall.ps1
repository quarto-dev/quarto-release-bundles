
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  FileFullPath  = gi $toolsDir\quarto*win.zip
  Destination   = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
rm $toolsDir\*.zip -ea 0

$files = get-childitem (Join-Path $toolsDir "bin/tools" ) -include *.exe -recurse
foreach ($file in $files) {
    New-Item "$file.ignore" -type file -force | Out-Null
}