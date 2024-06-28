# Quarto releases to package managers

- [Chocolatey package for Quarto](#chocolatey-package-for-quarto)
- [Winget package for Quarto](#winget-package-for-quarto)
- [Scoop package for Quarto](#scoop-package-for-quarto)
- [Conda feedstock for Quarto](#conda-feedstock-for-quarto)
- [Pypi quarto-cli version](#pypi-quarto-cli-version)

## Chocolatey package for Quarto

This repo contains the source code of choco quarto bundle. Only stable release are deployed to Quarto.

### About the chocolatey bundle

This repo will build a full offline portable `nupkg` package to be pusblished on <https://community.chocolatey.org> repository. 
The bundle contains the Windows ZIP file version from https://github.com/quarto-dev/quarto-cli/releases/latest which is downloaded at build time.
After installing the chocolatey package, `quarto` will be available in PATH thanks to Chocolatey shims mechanism.

### How it works ?

- This package contains the `nuspec` file for the quarto bundle to publish to <https://community.chocolatey.org>

- A new bundle is to be built for Chocolatey at each stable release. The release process to <https://community.chocolatey.org/packages/quarto/> is manually trigger with the Github Action workflow.

- Files are stored in `chocolatey` directory: 
  - `update.ps1` will fetch the new information, updtate the required file and build a new `.nupkg`
  - Other files are to be included in the bundle. 

- A github action workflow is here to ease the above process and publish to the community repo.

## Winget package for Quarto

Due to limitation (see #1), the winget package is manually created an deployed from a fork of official repo <https://github.com/microsoft/winget-pkgs>. 
Manifest lives at <https://github.com/microsoft/winget-pkgs/tree/master/manifests/p/Posit/Quarto>.

The manifests updates are done by community and not Quarto Team. Usually once we release on `quarto-cli` repo, it will be seen and trigger automated PR creating set up by some users. As of 06/2024, this done by <https://github.com/SpecterShell/Dumplings> automation. ([PR example for 1.4.557](https://github.com/microsoft/winget-pkgs/pull/160399))

## Scoop package for Quarto

Scoop (<https://scoop.sh/>) manifest are in pull-mode. Manifest for Quarto is [Extras bucket](https://github.com/ScoopInstaller/Extras/blob/master/bucket/quarto.json) and automatically updated. 

Another Scoop bucket at <https://github.com/cderv/r-bucket> is offering Quarto, in both stable and also prerelease version. Automatically updated too. It is maintained by @cderv from the Quarto team.

## Conda feedstock for Quarto

It lives at <https://github.com/conda-forge/quarto-feedstock/> and community maintained with our help. Release should be done there at each stable release. 

## Pypi quarto-cli version 

It lives at <https://github.com/quarto-dev/quarto-cli-pypi> and maintained by the Quarto team. Release is done there at each stable release. 
