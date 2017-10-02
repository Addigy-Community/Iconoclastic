#!/bin/bash

# 

function resampleSource() {
# $1=fileName; $2=${f}; $3=$filePath
# Define and create working directory for Iconoclastic.
    workingDir="$HOME/.iconoclastic/$1.iconset"
    /bin/mkdir -p "${workingDir}"

# Resample source image into iconset.
    /usr/bin/sips -z 16 16     "$2" --out "${workingDir}/icon_16x16.png"
    /usr/bin/sips -z 32 32     "$2" --out "${workingDir}/icon_16x16@2x.png"
    /usr/bin/sips -z 32 32     "$2" --out "${workingDir}/icon_32x32.png"
    /usr/bin/sips -z 64 64     "$2" --out "${workingDir}/icon_32x32@2x.png"
    /usr/bin/sips -z 128 128   "$2" --out "${workingDir}/icon_128x128.png"
    /usr/bin/sips -z 256 256   "$2" --out "${workingDir}/icon_128x128@2x.png"
    /usr/bin/sips -z 256 256   "$2" --out "${workingDir}/icon_256x256.png"
    /usr/bin/sips -z 512 512   "$2" --out "${workingDir}/icon_256x256@2x.png"
    /usr/bin/sips -z 512 512   "$2" --out "${workingDir}/icon_512x512.png"

# Copy source image into workingDir.
    /bin/cp "$2" "${workingDir}/icon_512x512@2x.png"

# Convert .inconset to .icns through convertToICNS.
    convertToICNS "$1" "${workingDir}" "$3"

# Clean up:
    /bin/rm -Rf "${workingDir}"
}

function convertToICNS () {
# $1=$fileName; $2=${f}; $3=$filePath
# Convert inconset to icns.
    /usr/bin/iconutil -c icns -o "${3}/${1}.icns" "${2}"

}

function convertToIconset() {
# $1=$fileName; $2=${f}; $3=$filePath
# Convert .icns to .iconset.
    /usr/bin/iconutil -c iconset -o "${3}/${1}.iconset" "${2}"
}

for f in "$@"; do

# Set fundamental variables.
    fileExtension=$(printf "${f}" | sed 's/.*\.//')
    fileName=$(printf "${f##*/}" | sed 's/\.[^.]*$//' )
    filePath=${f%/*}

# Determine function use based on variables.
    if [[ $fileExtension = 'icns' ]]; then
        convertToIconset "$fileName" "${f}" "$filePath"
    else
        if [[ $fileExtension = 'iconset' ]]; then
            convertToICNS "$fileName" "${f}" "$filePath"
        else
            resampleSource  "$fileName" "${f}" "$filePath"
        fi
    fi

done

exit 0
