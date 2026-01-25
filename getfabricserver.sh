#!/bin/sh
set -e

MINECRAFT_VERSION=$1

if [ -z "${MINECRAFT_VERSION}" ]; then
    echo "Usage: $0 <minecraft version>"
    exit 1
fi

rm -f fabric.jar

if [ -f /fabric_version.txt ]; then
    . /fabric_version.txt
    
    LATEST_FABRIC_LOADER=$LOADER
    LATEST_INSTALLER=$INSTALLER
else
    echo "Error: /fabric_version.txt not found!"
    exit 1
fi

if [ -z "${LATEST_FABRIC_LOADER}" ] || [ -z "${LATEST_INSTALLER}" ]; then
    echo "Error: failed to retrieve versions from fabric_version.txt"
    exit 1
fi

FABRIC_DOWNLOAD_URL="https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${LATEST_FABRIC_LOADER}/${LATEST_INSTALLER}/server/jar"

echo "------------------------------"
echo "Minecraft Version:               ${MINECRAFT_VERSION}"
echo "Latest Fabric Loader Version:    ${LATEST_FABRIC_LOADER}"
echo "Latest Fabric Installer Version: ${LATEST_INSTALLER}"
echo "Downloading URL:                 ${FABRIC_DOWNLOAD_URL}"
echo "------------------------------"

curl -f -s -o fabric.jar "${FABRIC_DOWNLOAD_URL}"
