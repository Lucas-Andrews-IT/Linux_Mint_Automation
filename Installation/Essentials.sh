#!/bin/bash

# Update package repositories
sudo apt update
echo

# Prompt for firewall
read -p "Do you want to enable the firewall? (yes/no): " enable_firewall
echo

if [[ $enable_firewall =~ ^[Yy][Ee][Ss]$ ]]; then
    sudo ufw enable
fi

# Prompt for Spotify installation
read -p "Do you want to install Spotify? (yes/no): " install_spotify
echo

if [[ $install_spotify =~ ^[Yy][Ee][Ss]$ ]]; then
    sudo apt install spotify-client -y
    echo "Spotify installation completed."
fi

# Prompt for Visual Studio Code installation
read -p "Do you want to install Visual Studio Code? (yes/no): " install_vscode
echo

if [[ $install_vscode =~ ^[Yy][Ee][Ss]$ ]]; then
    sudo apt install code -y
    echo "Visual Studio Code installation completed."
fi

# Prompt for Brave web browser installation
read -p "Do you want to install Brave web browser? (yes/no): " install_brave
echo

if [[ $install_brave =~ ^[Yy][Ee][Ss]$ ]]; then
    sudo apt install apt-transport-https curl -y
    curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser -y
    echo "Brave web browser installation completed."
fi

# ... (Other installations)

# Prompt for Synth-Shell installation and theme selection
read -p "Do you want to install Synth-Shell and apply a purple theme? (yes/no): " install_synthshell
echo

if [[ $install_synthshell =~ ^[Yy][Ee][Ss]$ ]]; then
    # ... (Install Synth-Shell steps)

    echo "Synth-Shell installation completed."
fi

echo "Installation completed."
