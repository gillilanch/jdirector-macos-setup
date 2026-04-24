#!/bin/bash

# JDirector macOS Setup Bootstrapper
# This script clones the repo to a temp folder, runs the installer, and cleans up.

set -e # Exit on error

# Text colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} Preparing JDirector Installation..."

# 1. Create a temporary directory
TEMP_DIR=$(mktemp -d)

# 2. Clone the repository
echo -e "${BLUE}==>${NC} Fetching latest files from GitHub..."
git clone --quiet https://github.com/gillilanch/jdirector-macos-setup.git "$TEMP_DIR"

# 3. Enter directory and run the main installer
cd "$TEMP_DIR"
if [ -f "install.sh" ]; then
    chmod +x install.sh
    ./install.sh
else
    echo "Error: install.sh not found in repository."
    exit 1
fi

# 4. Cleanup is handled automatically by the OS /tmp or manually here
echo -e "${BLUE}==>${NC} Cleaning up..."
cd ~
rm -rf "$TEMP_DIR"

echo -e "${GREEN}==> Installation Complete!${NC}"