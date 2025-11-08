#!/bin/sh

set -e

# Configuration
REPO_USER="DiegoChajtur"
REPO_NAME="opinionated-debian"
REPO_BRANCH="main"
PLAYBOOK_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${REPO_BRANCH}/bootstrap.yaml"
ENV_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${REPO_BRANCH}/.env"

# Ensure non-interactive mode
export DEBIAN_FRONTEND=noninteractive

echo "==> Installing Ansible..."
sudo apt-get update -qq
sudo apt-get install -y -qq ansible curl

echo "==> Downloading configuration files..."
curl -fsSL "${PLAYBOOK_URL}" -o /tmp/bootstrap.yaml


if [ ! -f /tmp/bootstrap.yaml ]; then
    echo "Error: Failed to download bootstrap.yaml"
    exit 1
fi

if [ ! -f /tmp/.env ]; then
    echo "No .env file"
    echo "Please create a .env file with:"
    echo "  GIT_USER_NAME=\"Your Name\""
    echo "  GIT_USER_EMAIL=\"your.email@example.com\""
    echo "  SSH_KEY_EMAIL=\"your.email@example.com\""
    exit 1
fi

echo "==> Running Ansible playbook..."
cd /tmp
sudo ansible-playbook bootstrap.yaml

echo "==> Cleaning up..."
rm -f /tmp/bootstrap.yaml /tmp/.env

echo ""
echo "============================================"
echo "Bootstrap complete!"
echo "Please log out and log back in for all changes to take effect."
echo "============================================"
