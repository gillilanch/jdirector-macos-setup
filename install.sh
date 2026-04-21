#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${BLUE}🚀 Starting JDirector Professional Installation...${NC}"

# 1. Homebrew & OpenJDK
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [[ $(uname -m) == 'arm64' ]] && eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
fi

if ! brew list openjdk &> /dev/null; then
    brew install openjdk
    sudo mkdir -p /Library/Java/JavaVirtualMachines/
    sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
fi

# 2. Move Folder & Set Permissions
echo "Installing to /Applications..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
sudo rm -rf "/Applications/JDirector"
sudo cp -R "$SCRIPT_DIR/JDirector" /Applications/

# Crucial: Give the folder to the user so the icon script can write to it
sudo chown -R "$USER":admin "/Applications/JDirector"
sudo chmod -R 775 "/Applications/JDirector"

# 3. Security & Permission Scrub
echo "🔓 Scrubbing macOS security flags..."
sudo xattr -cr "/Applications/JDirector"
sudo chmod -R +x "/Applications/JDirector/Apantac jDirector.app/Contents/MacOS"
sudo chmod +x "/Applications/JDirector/Apantac_JDirector.jar"

# 4. Create Desktop Shortcut
echo "🖥 Creating Desktop Shortcut..."
LAUNCHER_PATH="$HOME/Desktop/Launch_JDirector.command"
cat <<EOF > "$LAUNCHER_PATH"
#!/bin/bash
java -jar "/Applications/JDirector/Apantac_JDirector.jar"
EOF
chmod +x "$LAUNCHER_PATH"

# 5. Apply Custom Icons (Revised Logic)
echo "🎨 Customizing folder and launcher icons..."
# We give the OS 2 seconds to "settle" the file move
sleep 2

# We run this as the USER, not as ROOT, to satisfy the Finder
sudo -u "$USER" osascript <<EOT
try
    set theApp to POSIX file "/Applications/JDirector/Apantac jDirector.app"
    set theFolder to POSIX file "/Applications/JDirector"
    set theLauncher to POSIX file "$LAUNCHER_PATH"
    
    tell application "Finder"
        set icon of (item theFolder) to icon of (item theApp)
        set icon of (item theLauncher) to icon of (item theApp)
        update (item theFolder)
    end tell
on error errStr number errNum
    log "Icon skip: " & errStr
end try
EOT

echo -e "${GREEN}✅ Setup Complete!${NC}"