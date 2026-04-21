# JDirector macOS Setup

This repository contains a one-click installer for the **JDirector** environment on macOS.

## 📦 What's Included
* **Homebrew**: macOS package manager.
* **OpenJDK**: Java Development Kit (required for JDirector).
* **JDirector App**: The full application folder including the `.app` and `.jar` files.

## 🚀 Installation

   ```bash
   /bin/bash -c "git clone https://github.com/gillilanch/jdirector-macos-setup.git /tmp/jd_install && cd /tmp/jd_install && chmod +x install.sh && ./install.sh && cd ~ && rm -rf /tmp/jd_install"