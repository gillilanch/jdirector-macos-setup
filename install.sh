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

# 2. Set Paths
SHELL_PROFILE="$HOME/.zshrc"
BREW_PREFIX=$(brew --prefix)
if ! grep -q "openjdk/bin" "$SHELL_PROFILE"; then
    echo -e "\n# Java Path for JDirector\nexport PATH=\"$BREW_PREFIX/opt/openjdk/bin:\$PATH\"\nexport CPPFLAGS=\"-I$BREW_PREFIX/opt/openjdk/include\"" >> "$SHELL_PROFILE"
fi

# 3. Move Folder & Change Ownership
echo "Installing to /Applications..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
sudo rm -rf "/Applications/JDirector"
sudo cp -R "$SCRIPT_DIR/JDirector" /Applications/

# GIVE USER PERMISSION (This fixes the -10006 error)
sudo chown -R $USER:admin "/Applications/JDirector"

# 4. Security & Permission Scrub
echo "🔓 Scrubbing macOS security flags..."
sudo xattr -cr "/Applications/JDirector"

echo "🔧 Repairing executable permissions..."
sudo chmod -R +x "/Applications/JDirector/Apantac jDirector.app/Contents/MacOS"
sudo chmod +x "/Applications/JDirector/Apantac_JDirector.jar"

# 5. Create Desktop Shortcut
echo "🖥 Creating Desktop Shortcut..."
LAUNCHER_PATH="$HOME/Desktop/Launch_JDirector.command"
cat <<EOF > "$LAUNCHER_PATH"
#!/bin/bash
java -jar "/Applications/JDirector/Apantac_JDirector.jar"
EOF
chmod +x "$LAUNCHER_PATH"

# 6. Apply Custom Icons
echo "🎨 Customizing folder and launcher icons..."
# Using the folder itself and the launcher file
osascript <<EOT
tell application "Finder"
    try
        set theApp to POSIX file "/Applications/JDirector/Apantac jDirector.app" as alias
        set theFolder to POSIX file "/Applications/JDirector" as alias
        set theLauncher to POSIX file "$LAUNCHER_PATH" as alias
        
        -- Copy icon from the app to the parent folder and the shortcut
        set icon of theFolder to icon of theApp
        set icon of theLauncher to icon of theApp
    on error errStr number errNum
        log "Icon error: " & errStr & " (" & errNum & ")"
    end try
end tell
EOT

echo -e "${GREEN}✅ Setup Complete!${NC}"