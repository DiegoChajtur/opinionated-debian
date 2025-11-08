#!/bin/sh
set -e

# Configuration
REPO_USER="DiegoChajtur"
REPO_NAME="opinionated-debian"
REPO_BRANCH="main"

# Ensure non-interactive mode
export DEBIAN_FRONTEND=noninteractive

#!/bin/bash
set -e

# Backup original
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Replace with proper Debian 13 (trixie) repositories
sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
EOF

# Add VS Code repo
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Now install everything
sudo apt-get update
sudo apt-get install -y curl wget git zsh tmux fzf ripgrep fd-find bat htop tree jq fonts-firacode ffmpeg imagemagick firefox-esr vlc libreoffice krita python3 nodejs golang default-jdk earlyoom code

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set theme
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

chsh -s /usr/bin/zsh

