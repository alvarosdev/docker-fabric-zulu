# Github Workflows

This repository contains two main workflows to automate the checking of new Fabric versions and the building of the Docker image.

## 1. Check for Fabric Updates (`check-updates.yml`)
**Schedule:** Runs daily at 23:59 UTC.

This workflow is responsible for checking if a new version of the Fabric Loader has been released.

**Steps:**
1.  **Extracts Minecraft Version**: Reads the `MC_VERSION` variable from `dockerimage.yml`.
2.  **Checks Stored Version**: Reads `fabric_version.txt`.
3.  **Fetches Latest Version**: Queries the Fabric Meta API.
4.  **Action**: If a new version is detected:
    *   It updates `fabric_version.txt` with the new version.
    *   Creates a new branch named `release/<MC_VERSION>-<FABRIC_VERSION>`.
    *   **Creates a Pull Request** to `main`.

## 2. Build and Push (`dockerimage.yml`)
**Trigger:** Pushes to `main` (triggered when the PR is merged).

This workflow builds the Docker image and pushes it to the GitHub Container Registry (GHCR).

**Steps:**
1.  **Builds**: Uses `docker buildx` to build a multi-arch image.
2.  **Tags**: Tags the image with `latest` and the Minecraft version.
3.  **Pushes**: Pushes the resulting image to `ghcr.io/als3bas/zulu-fabricmc`.
