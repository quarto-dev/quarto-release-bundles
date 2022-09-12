# Chocolatey package for Quarto

This repo contains the source code of choco quarto bundle

## About the chocolatey bundle

This repo will build a full offline portable `nupkg` package to be pusblished on <https://community.chocolatey.org> repository. 
The bundle contains the Windows ZIP file version from https://github.com/quarto-dev/quarto-cli/releases/latest which is downloaded at build time.
After installing the chocolatey package, `quarto` will be available in PATH thanks to Chocolatey shims mechanism.

## How it works ?

- This package contains the `nuspec` file for the quarto bundle to publish to <https://community.chocolatey.org>

- A new bundle is to be built for Chocolatey at each stable release. The release process to <https://community.chocolatey.org/packages/quarto/> is manually trigger with the Github Action workflow.

- Files are stored in `chocolatey` directory: 
  - `update.ps1` will fetch the new information, updtate the required file and build a new `.nupkg`
  - Other files are to be included in the bundle. 

- A github action workflow is here to ease the above process and publish to the community repo.