#!/bin/bash

set -e # Exit on any error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 

#!/bin/bash
set -e

# --- NEW SECTION: Prime Sudo ---
echo -e "${BLUE}==>${NC} Checking for administrative access..."
# This asks for your password once at the start
if ! sudo -v; then
    echo -e "${RED}Error: This script requires administrator access.${NC}"
    exit 1
fi

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
# -------------------------------

# ... the rest of your script ...

echo -e "${BLUE}🚀 Starting JDirector Professional Installation...${NC}"

# 1. Homebrew Installation & Path Activation
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Manually detect and load Homebrew based on Mac architecture
    if [ -f "/opt/homebrew/bin/brew" ]; then
        # Apple Silicon (M1/M2/M3)
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# FINAL CHECK: If brew is still not found, we can't continue.
if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ Error: Homebrew installation failed or could not be located.${NC}"
    echo "Please try installing Homebrew manually from brew.sh first."
    exit 1
fi

# 2. OpenJDK Installation
echo -e "${BLUE}==>${NC} Checking OpenJDK..."
if ! brew list openjdk &> /dev/null; then
    echo "Installing OpenJDK via Homebrew..."
    brew install openjdk
fi

# Ensure we have the prefix for the next steps
BREW_PREFIX=$(brew --prefix)

echo -e "${BLUE}==>${NC} Configuring Java system links..."
sudo mkdir -p /Library/Java/JavaVirtualMachines/
sudo ln -sfn "$BREW_PREFIX/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk

# 3. Set Paths for ZSH
SHELL_PROFILE="$HOME/.zshrc"
if ! grep -q "openjdk/bin" "$SHELL_PROFILE"; then
    echo "Updating PATH in $SHELL_PROFILE..."
    echo -e "\n# Java Path for JDirector\nexport PATH=\"$BREW_PREFIX/opt/openjdk/bin:\$PATH\"\nexport CPPFLAGS=\"-I$BREW_PREFIX/opt/openjdk/include\"" >> "$SHELL_PROFILE"
fi

# 4. Move Folder & Set Permissions
echo -e "${BLUE}==>${NC} Installing to /Applications..."
SCRIPT_DIR="$(pwd)"

if [ -d "$SCRIPT_DIR/JDirector" ]; then
    sudo rm -rf "/Applications/JDirector"
    sudo cp -R "$SCRIPT_DIR/JDirector" /Applications/
    sudo chown -R "$USER":admin "/Applications/JDirector"
else
    echo -e "${RED}❌ Error: 'JDirector' folder not found in $(pwd)${NC}"
    exit 1
fi

# 5. Security & Permission Scrub
echo -e "${BLUE}==>${NC} 🔓 Scrubbing macOS security flags..."
sudo xattr -cr "/Applications/JDirector"
# Make the actual binary executable if it exists
[ -d "/Applications/JDirector/Apantac jDirector.app" ] && sudo chmod -R +x "/Applications/JDirector/Apantac jDirector.app"
sudo chmod +x "/Applications/JDirector/Apantac_JDirector.jar"

echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "---------------------------------------------------"
echo "JDirector is now ready in your Applications folder."
echo "---------------------------------------------------"