#!/bin/bash

set -e  # Exit if any command fails

# Define Go version
GO_VERSION="1.23.0"

echo "Installing dependencies..."
if command -v dnf &>/dev/null; then
    sudo dnf install -y git curl tar
elif command -v zypper &>/dev/null; then
    sudo zypper install -y git curl tar
else
    echo "Unsupported package manager. Install Git, curl, and tar manually."
    exit 1
fi

echo "Removing old Go installation..."
sudo rm -rf /usr/local/go

echo "Downloading and installing Go $GO_VERSION..."
curl -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

echo "Setting up Go environment..."
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin:/usr/local/bin' | sudo tee -a /etc/profile
source /etc/profile

echo "Installing gum..."
go install github.com/charmbracelet/gum@latest

echo "Moving gum to /usr/local/bin..."
sudo mv ~/go/bin/gum /usr/local/bin/

echo "Verifying installation..."
if command -v gum &>/dev/null; then
    echo "gum successfully installed!"
    gum --version
else
    echo "gum installation failed."
    exit 1
fi
