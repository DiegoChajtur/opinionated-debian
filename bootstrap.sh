#!/bin/sh
set -e

# Configuration
read -p "Enter your email for git config: " EMAIL
read -p "Enter your name for git config: " NAME

git config --global user.email "$EMAIL" 
git config --global user.name "$NAME" 

ssh-keygen -t rsa -b 4096 -C "$EMAIL" 


# Ensure non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# Backup original sources
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Replace with proper Debian 13 repositories
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

# Install packages
sudo apt-get update
sudo apt-get install -y curl wget git zsh tmux fzf ripgrep fd-find bat htop tree jq fonts-firacode ffmpeg firefox-esr vlc libreoffice python3 nodejs npm golang default-jdk earlyoom code gnome-themes-extra gtk2-engines-murrine gimp 


# Install pnpm globally
sudo npm install -g pnpm

# Configure earlyoom
sudo systemctl daemon-reload
sudo systemctl enable earlyoom
sudo systemctl start earlyoom

# Set zsh as default system shell
sudo chsh -s /usr/bin/zsh $USER

# Install Oh My Zsh
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


cd /tmp

wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb

sudo apt install ./protonvpn-stable-release_1.0.8_all.deb

sudo apt update

sudo apt install proton-vpn-gnome-desktop


wget https://proton.me/download/PassDesktop/linux/x64/ProtonPass.deb

sudo apt install ./ProtonPass.deb



