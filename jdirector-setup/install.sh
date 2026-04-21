#!/bin/bash

echo "🚀 Starting JDirector Installation..."

# 1. Check/Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew is already installed."
fi

# 2. Check/Install OpenJDK
if ! brew list openjdk &> /dev/null; then
    echo "Installing OpenJDK..."
    brew install openjdk
    sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
else
    echo "✅ OpenJDK is already installed."
fi

# 3. Set Paths
SHELL_PROFILE="$HOME/.zshrc"
if ! grep -q "openjdk/bin" "$SHELL_PROFILE"; then
    echo "Configuring Java paths..."
    echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> "$SHELL_PROFILE"
    source "$SHELL_PROFILE"
fi

# 4. Install JDirector App Folder
echo "Moving JDirector to /Applications..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ -d "$SCRIPT_DIR/JDirector" ]; then
    cp -R "$SCRIPT_DIR/JDirector" /Applications/
    echo "✅ JDirector installed successfully in /Applications."
else
    echo "❌ Error: JDirector folder not found in repository."
    exit 1
fi

echo "🎉 Setup Complete! Please restart your terminal."