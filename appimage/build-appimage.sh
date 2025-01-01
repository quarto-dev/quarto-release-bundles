#! /usr/bin/env bash

# -e - Exit immediately if any command fails.
# -u - Exit if an unset variable is invoked.
# -o pipefail - Exit if a command in a piped series of commands fails.
set -euo pipefail

DIR_OUTPUT="./AppDir"
URL_RELEASE="https://quarto.org/docs/download/_download.json"
PLATFORM_TARGET=$TARGET_ARCH

get_current_release_build() {
    echo "Trying to get latest release build."

    # Download release info document.
    wget --output-document "release-info.json" $URL_RELEASE

    # Get latest download url. Matching here a fixed host as security
    # precaution.
    myurl=$(grep -oP "download_url\": \"\Khttps://github.com/quarto-dev/quarto-cli/.*-linux-${PLATFORM_TARGET}.*.tar.gz(?=\")" release-info.json)

    # Download release tarball.
    wget --output-document "quarto-release.tar.gz" $myurl
}

extract_release_build() {
    echo "Extracting latest release build."

    mkdir -p "quarto-release"
    tar --strip-components=1 -xvf "quarto-release.tar.gz" --directory "quarto-release"
}

get_appimage_builder() {
    echo "Getting appimage builder."

    if [ $PLATFORM_TARGET = "amd64" ]
    then
        wget --output-document "appimagetool.AppImage" "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
    elif [ $PLATFORM_TARGET = "arm64" ]
    then
        wget --output-document "appimagetool.AppImage" "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-aarch64.AppImage"
    else
        echo "Unsupported target platform."
        exit 1
    fi

    chmod a+x ./appimagetool.AppImage
}

prepare_appimage() {
    echo "Preparing appimage directory."

    mkdir -p $DIR_OUTPUT

    # Copy files from release tarball.
    cp -a -r ./quarto-release/ $DIR_OUTPUT/usr/

    # Copy other necessary files.
    cp ./appimage/AppRun $DIR_OUTPUT/
    cp ./appimage/quarto.desktop $DIR_OUTPUT/
    cp ./appimage/quarto.svg $DIR_OUTPUT/
}

build_appimage() {
    echo "Building quarto appimage."

    ./appimagetool.AppImage $DIR_OUTPUT Quarto-${PLATFORM_TARGET}.AppImage
}

get_current_release_build
extract_release_build
get_appimage_builder
prepare_appimage
build_appimage
