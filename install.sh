#!/bin/bash

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ Error: This script is designed for macOS only.${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 Starting JDirector Installation...${NC}"

# 1. Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [[ $(uname -m) == 'arm64' ]] && eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
else
    echo -e "${GREEN}✅ Homebrew is already installed.${NC}"
fi

# 2. OpenJDK
if ! brew list openjdk &> /dev/null; then
    echo "Installing OpenJDK..."
    brew install openjdk
    sudo mkdir -p /Library/Java/JavaVirtualMachines/
    sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
else
    echo -e "${GREEN}✅ OpenJDK is already installed.${NC}"
fi

# 3. Paths
SHELL_PROFILE="$HOME/.zshrc"
BREW_PREFIX=$(brew --prefix)
if ! grep -q "openjdk/bin" "$SHELL_PROFILE"; then
    echo "Updating PATH..."
    echo -e "\n# Java Path for JDirector\nexport PATH=\"$BREW_PREFIX/opt/openjdk/bin:\$PATH\"\nexport CPPFLAGS=\"-I$BREW_PREFIX/opt/openjdk/include\"" >> "$SHELL_PROFILE"
fi

# 4. Move Folder
echo "Moving JDirector to /Applications..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -d "$SCRIPT_DIR/JDirector" ]; then
    sudo rm -rf "/Applications/JDirector"
    sudo cp -R "$SCRIPT_DIR/JDirector" /Applications/
else
    echo -e "${RED}❌ Error: JDirector folder not found.${NC}"
    exit 1
fi

# 5. Security Bypass (xattr)
echo "🔓 Removing macOS quarantine flags..."
# This removes the 'com.apple.quarantine' attribute so the .app and .jar open immediately
sudo xattr -rd com.apple.quarantine "/Applications/JDirector"
echo -e "${GREEN}✅ Security flags removed.${NC}"

echo -e "${BLUE}🎉 Setup Complete! You can now open JDirector from your Applications folder.${NC}"