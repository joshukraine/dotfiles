#!/bin/bash

# Downloading all files from a specific directory in a GitHub
# repository using curl can be tricky because GitHub does not
# provide direct links to files within directories for curl to
# handle recursively. However, you can use the GitHub API to
# list the files and then download them individually.
#
# 1. List the files in the directory using the GitHub API.
# 2. Download each file using curl.
#
# First, ensure you have jq installed to parse JSON data.
# If you don’t have it installed, you can install it with the
# following command (assuming you’re using a Debian-based system):
#
# sudo apt-get install jq
#
# Or if you're on macOS using Homebrew:
#
# brew install jq
#
# Before running this script, be sure to make it executable:
# chmod +x download_files.sh
#
# Usage:
# 1. Set the GitHub repository information (REPO, BRANCH, DIR).
# 2. Set the destination directory where the files will be saved (DEST_DIR).
# 3. Run the script: ./download_files.sh

# GitHub repository information
REPO="sxyazi/yazi"
BRANCH="latest"
DIR="yazi-config/preset"

# Destination directory
DEST_DIR="./downloaded_files"

# Create the destination directory if it doesn't exist
mkdir -p "${DEST_DIR}"

# Fetch the file list from GitHub API
FILE_LIST=$(curl -s "https://api.github.com/repos/${REPO}/contents/${DIR}?ref=${BRANCH}" | jq -r '.[].download_url')

# Loop through each file URL and download it
for FILE_URL in ${FILE_LIST}; do
  FILE_NAME=$(basename "${FILE_URL}")
  echo "Downloading ${FILE_NAME}..."
  curl -s -L "${FILE_URL}" -o "${DEST_DIR}/${FILE_NAME}"
done

echo "All files downloaded to ${DEST_DIR}"

# Thank you ChatGPT for this script 🙂
