# Chocolatey package for Quarto

This repo contains the source code of choco quarto bundle

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