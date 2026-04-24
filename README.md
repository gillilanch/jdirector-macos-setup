# JDirector macOS Setup #

## Overview ##
A streamlined automated installer to configure **JDirector** on macOS environments. This script handles dependencies, directory structures, and permission configurations in one go.

---

## 🚀 Quick Start

Run the following command in your Terminal to begin the installation. This will download the latest configuration and set up your environment automatically.

```bash
curl -sSL [https://raw.githubusercontent.com/gillilanch/jdirector-macos-setup/main/setup.sh](https://raw.githubusercontent.com/gillilanch/jdirector-macos-setup/main/setup.sh) | bash

🛠️ What this script does
The installer automates the manual setup process to ensure consistency across machines:

Dependency Check: Verifies Homebrew and required CLI tools.

Environment Setup: Creates necessary directories in /usr/local/ or ~/.

Permissions: Configures execution bits for JDirector binaries.

Cleanup: Removes all temporary installation files once finished.

📋 Prerequisites
macOS: 12.0 (Monterey) or newer recommended.

Git: Should be installed (if not, the script will prompt you).

Sudo Access: You may be prompted for your password to set system permissions.

🛠 Manual Installation
If you prefer to audit the code before running it, you can install manually:

1. Clone the repo:

git clone [https://github.com/gillilanch/jdirector-macos-setup.git](https://github.com/gillilanch/jdirector-macos-setup.git)

2. Run the installer:

cd jdirector-macos-setup
chmod +x install.sh
./install.sh

🤝 Contributing
Found a bug or have a feature request? Please open an Issue or submit a Pull Request.

Maintained by gillilanch