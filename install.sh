#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${BLUE}🚀 Starting JDirector Professional Installation...${NC}"

# 1. Homebrew & OpenJDK (Standard Logic)
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [[ $(uname -m) == 'arm64' ]] && eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
fi

if ! brew list openjdk &> /dev/null; then
    brew install openjdk
    sudo mkdir -p /Library/Java/JavaVirtualMachines/
    sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
fi

# 2. Move Folder
echo "Installing to /Applications..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
sudo rm -rf "/Applications/JDirector"
sudo cp -R "$SCRIPT_DIR/JDirector" /Applications/

# 3. Security & Permission Scrub (The "Nuclear" Fix)
echo "🔓 Scrubbing macOS security flags..."
# -cr removes ALL extended attributes recursively (more thorough than just quarantine)
sudo xattr -cr "/Applications/JDirector/Apantac jDirector.app"
sudo xattr -cr "/Applications/JDirector/Apantac_JDirector.jar"

echo "🔧 Forcing internal executable permissions..."
# This targets the hidden launcher inside the .app bundle
sudo chmod -R +x "/Applications/JDirector/Apantac jDirector.app/Contents/MacOS"
sudo chmod +x "/Applications/JDirector/Apantac_JDirector.jar"

# 4. Plan B: Create a Desktop Shortcut to the JAR
# Since the .jar works, let's make it easy to access just in case.
echo "🖥 Creating Desktop Shortcut to the JAR..."
cat <<EOF > ~/Desktop/Launch_JDirector.command
#!/bin/bash
java -jar "/Applications/JDirector/Apantac_JDirector.jar"
EOF
chmod +x ~/Desktop/Launch_JDirector.command

echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "1. Try opening 'Apantac jDirector' in Applications."
echo "2. If it still fails, double-click 'Launch_JDirector' on your Desktop."