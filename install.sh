#!/bin/sh
set -e

# Configuration
REPO_USER="DiegoChajtur"
REPO_NAME="opinionated-debian"
REPO_BRANCH="main"

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
sudo apt-get install -y curl wget git zsh tmux fzf ripgrep fd-find bat htop tree jq fonts-firacode ffmpeg imagemagick firefox-esr vlc libreoffice krita python3 nodejs npm golang default-jdk earlyoom code

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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Configure .zshrc with Powerlevel10k
cat > ~/.zshrc <<'ZSHRC'
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"

plugins=(git docker sudo zsh-autosuggestions)
skip_global_compinit=1

source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lah'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

HISTSIZE=10000
SAVEHIST=10000

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC

# Create Powerlevel10k config
cat > ~/.p10k.zsh <<'P10K'
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
typeset -g POWERLEVEL9K_DIR_FOREGROUND=blue
typeset -g POWERLEVEL9K_VCS_FOREGROUND=green
P10K

