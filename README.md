# Chocolatey package for Quarto

This repo contains the source code of choco quarto bundle

## About the chocolatey bundle

This repo will build a full offline portable `nupkg` package to be pusblished on <https://community.chocolatey.org> repository. 
The bundle contains the Windows ZIP file version from https://github.com/quarto-dev/quarto-cli/releases/latest which is downloaded at build time.
After installing the chocolatey package, `quarto` will be available in PATH thanks to Chocolatey shims mechanism.

## How it works ?

- This package contains the `nuspec` file for the quarto bundle to publish to <https://community.chocolatey.org>

- A new bundle is to be built for Chocolatey at each stable release. 

- [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au) is used to automate the process: 

  - Checking if a new version is available
  - If so, update the file that requires new value based on new version 
  - and create a new package to publish

  This happens in `update.ps1`. 

  _This tools currently contraints the repo to have a quarto folder with the `.nuspec`._


- A github action workflow is here to ease the above process and publish to the community repo is needed. 