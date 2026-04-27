#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${BLUE}🚀 Starting JDirector Professional Installation...${NC}"

# 1. Homebrew & OpenJDK
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    # NONINTERACTIVE=1 allows brew to install without hitting 'Enter'
    /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Immediately load brew into this session so the next commands work
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Double check brew is now accessible
if ! command -v brew &> /dev/null; then
    echo -e "${RED}Error: Homebrew installation failed or is not in PATH.${NC}"
    exit 1
fi

echo -e "${BLUE}==>${NC} Installing OpenJDK..."
brew install openjdk

# Use brew --prefix to find the exact path
BREW_PREFIX=$(brew --prefix)

echo -e "${BLUE}==>${NC} Configuring Java system links..."
sudo mkdir -p /Library/Java/JavaVirtualMachines/
sudo ln -sfn "$BREW_PREFIX/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk

# 2. Set Paths for ZSH
SHELL_PROFILE="$HOME/.zshrc"
if ! grep -q "openjdk/bin" "$SHELL_PROFILE"; then
    echo "Updating PATH in $SHELL_PROFILE..."
    echo -e "\n# Java Path for JDirector\nexport PATH=\"$BREW_PREFIX/opt/openjdk/bin:\$PATH\"\nexport CPPFLAGS=\"-I$BREW_PREFIX/opt/openjdk/include\"" >> "$SHELL_PROFILE"
fi

# 3. Move Folder & Set Permissions
echo -e "${BLUE}==>${NC} Installing to /Applications..."
# If running via setup.sh, the files are in the current directory
SCRIPT_DIR="$(pwd)"

if [ -d "$SCRIPT_DIR/JDirector" ]; then
    sudo rm -rf "/Applications/JDirector"
    sudo cp -R "$SCRIPT_DIR/JDirector" /Applications/
    sudo chown -R "$USER":admin "/Applications/JDirector"
else
    echo -e "${RED}Error: JDirector source folder not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# 4. Security & Permission Scrub
echo -e "${BLUE}==>${NC} 🔓 Scrubbing macOS security flags..."
sudo xattr -cr "/Applications/JDirector"
# Ensure the app and jar are executable
sudo chmod -R +x "/Applications/JDirector/Apantac jDirector.app/Contents/MacOS" 2>/dev/null || true
sudo chmod +x "/Applications/JDirector/Apantac_JDirector.jar"

echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "---------------------------------------------------"
echo "JDirector is now ready in your Applications folder."
echo "Note: Restart your terminal or run 'source ~/.zshrc' to update your Java path."
echo "---------------------------------------------------"