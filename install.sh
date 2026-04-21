#!/bin/bash

# Define colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting JDirector Installation...${NC}"

# 1. Check/Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to path for the current session
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✅ Homebrew is already installed.${NC}"
fi

# 2. Check/Install OpenJDK
if ! brew list openjdk &> /dev/null; then
    echo "Installing OpenJDK..."
    brew install openjdk
    # Link it so macOS recognizes it as a JVM
    sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
else
    echo -e "${GREEN}✅ OpenJDK is already installed.${NC}"
fi

# 3. Set Paths in .zshrc
SHELL_PROFILE="$HOME/.zshrc"
JAVA_BIN_PATH='export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"'

if ! grep -q "openjdk/bin" "$SHELL_PROFILE"; then
    echo "Updating PATH in $SHELL_PROFILE..."
    echo "" >> "$SHELL_PROFILE"
    echo "# Java Path for JDirector" >> "$SHELL_PROFILE"
    echo "$JAVA_BIN_PATH" >> "$SHELL_PROFILE"
    echo 'export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"' >> "$SHELL_PROFILE"
fi

# 4. Install JDirector App
echo "Installing JDirector folder to /Applications..."
# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ -d "$SCRIPT_DIR/JDirector" ]; then
    # Remove existing version if it exists to prevent permission errors
    sudo rm -rf "/Applications/JDirector"
    sudo cp -R "$SCRIPT_DIR/JDirector" /Applications/
    echo -e "${GREEN}✅ JDirector folder moved to /Applications successfully.${NC}"
else
    echo -e "\033[0;31m❌ Error: JDirector folder not found in this directory.\033[0m"
    exit 1
fi

echo -e "${BLUE}🎉 Setup Complete! Please restart your terminal or run 'source ~/.zshrc'${NC}"