
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  FileFullPath  = gi $toolsDir\quarto*win.zip
  Destination   = $toolsDir
}

Get-ChocolateyUnzip @packageArgs
rm $toolsPath\*.zip -ea 0
