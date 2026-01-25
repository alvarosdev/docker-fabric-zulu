#!/bin/sh
set -e

MINECRAFT_VERSION=$1

if [ -z "${MINECRAFT_VERSION}" ]; then
    echo "Usage: $0 <minecraft version>"
    exit 1
fi

# Remove old jar if exists
rm -f fabric.jar

echo "Fetching latest Fabric versions..."

# Fetch versions
LATEST_FABRIC_LOADER=$(curl -s https://meta.fabricmc.net/v2/versions/loader | jq -r '.[0].version')
LATEST_INSTALLER=$(curl -s https://meta.fabricmc.net/v2/versions/installer | jq -r '.[0].version')

if [ -z "${LATEST_FABRIC_LOADER}" ] || [ -z "${LATEST_INSTALLER}" ]; then
    echo "Error: Failed to fetch Fabric versions from meta.fabricmc.net"
    exit 1
fi

FABRIC_DOWNLOAD_URL="https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${LATEST_FABRIC_LOADER}/${LATEST_INSTALLER}/server/jar"

echo "------------------------------"
echo "Minecraft Version:               ${MINECRAFT_VERSION}"
echo "Latest Fabric Loader Version:    ${LATEST_FABRIC_LOADER}"
echo "Latest Fabric Installer Version: ${LATEST_INSTALLER}"
echo "Downloading URL:                 ${FABRIC_DOWNLOAD_URL}"
echo "------------------------------"

# Download with fail flag (-f) to error out on 404s
curl -f -s -o fabric.jar "${FABRIC_DOWNLOAD_URL}"
