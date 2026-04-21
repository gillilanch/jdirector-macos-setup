# JDirector macOS Auto-Installer 🚀

This repository provides a streamlined, automated way to set up the **JDirector** environment on macOS. It handles all dependencies, security flags, and directory placements in one go.

## 🛠 What this script does
Homebrew: Checks for installation; installs it if missing.

OpenJDK: Installs and configures the Java environment.

Path Configuration: Automatically updates your .zshrc so java is recognized globally.

App Deployment: Moves the JDirector folder to your /Applications directory.

Security Scrub: Removes macOS "Quarantine" flags so the app and JAR open without security warnings.


## 📂 Manual Installation
If you prefer to clone the repository manually:

1. Clone the repo:

```bash
git clone [https://github.com/gillilanch/jdirector-macos-setup.git](https://github.com/gillilanch/jdirector-macos-setup.git)
cd jdirector-macos-setup
```

2. Run the installer:

```bash
chmod +x install.sh
./install.sh
```

## ⚡️ Quick Start (Recommended)

To install everything automatically, open your **Terminal** (Cmd + Space, type "Terminal") and paste the following command:

```bash
/bin/bash -c "git clone https://github.com/gillilanch/jdirector-macos-setup.git /tmp/jd_install && cd /tmp/jd_install && chmod +x install.sh && ./install.sh && cd ~ && rm -rf /tmp/jd_install"
```

## ❓ Troubleshooting

**Security & Privacy**

If macOS blocks the app:

1. Open System Settings > Privacy & Security.

2. Scroll down to the "Security" section.

3. Click Open Anyway next to the JDirector notification.

**Java Command Not Found**
If you see a `java: command not found` error immediately after installation, simply restart your terminal or run:

```bash
source ~/.zshrc
```

*Created by gillilanch*