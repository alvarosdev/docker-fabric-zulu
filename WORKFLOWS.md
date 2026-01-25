# Github Workflows

This repository contains two main workflows to automate the checking of new Fabric versions and the building of the Docker image.

## 1. Check for Fabric Updates (`check-updates.yml`)
**Schedule:** Runs daily at 23:59 UTC.

This workflow is responsible for checking if a new version of the Fabric Loader has been released.

**Steps:**
1.  **Extracts Minecraft Version**: Reads the `MC_VERSION` variable from `dockerimage.yml` to know which Minecraft base to use.
2.  **Checks Stored Version**: Reads `fabric_version.txt` from the repository to see the last built version.
3.  **Fetches Latest Version**: Queries the Fabric Meta API (`https://meta.fabricmc.net/v2/versions/loader`) to get the latest loader version.
4.  **Compares**: If the latest version from the API is different from the stored version:
    *   It updates `fabric_version.txt` with the new version.
    *   It commits and pushes this change to `main` to persist the state (avoiding loops).
    *   It creates a new branch named `release/<MC_VERSION>-<FABRIC_VERSION>` and pushes it.

## 2. Build and Push (`dockerimage.yml`)
**Trigger:** Pushes to branches starting with `release/*`.

This workflow builds the Docker image and pushes it to the GitHub Container Registry (GHCR).

**Steps:**
1.  **Builds**: Uses `docker buildx` to build a multi-arch image (amd64, arm64).
2.  **Tags**: Tags the image with `latest` and the Minecraft version.
3.  **Pushes**: Pushes the resulting image to `ghcr.io/als3bas/zulu-fabricmc`.
