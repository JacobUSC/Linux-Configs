#!/bin/bash
# Jacobs's Linux Setup Script
# For Linux Mint 21 Cinnamon DE
# https://www.linuxmint.com/
# version 1.0

# Variables
DISTRO="Linux Mint 21.3"

# Startup Checks
UNAME=$(uname)
if [[ $UNAME != *"Linux"* ]]; then
  echo "Error: Script must be ran on Linux"
  exit 1
fi
INSTALL_DIR=$(pwd)
if [[ $INSTALL_DIR != *"Linux-Configs" ]]; then
  echo "Error: Script must be ran from inside [Linux-Configs] directory"
  echo "Hint: Try using [cd Linux-Configs] to enter the directory"
  exit 1
fi
if [ -f /etc/os-release ]; then
  . /etc/os-release
else
  echo "Error: /etc/os-release not found"
  exit 1
fi
if [[ $DISTRO != "$PRETTY_NAME" ]]; then
  echo "Error: Script is not running on $DISTRO"
  echo "You are running $PRETTY_NAME"
  echo "If you are trying to run this on WSL use the WSL script"
  exit 1
fi
sudo apt update -y
sudo apt upgrade -y
flatpak update -y

# Set Configs
cp configs/.nanorc ~
echo "setting nano config"

# Dependacy Setup
sudo apt install git -y
sudo apt install wget -y

# apt Program Installs
APT_PROGRAMS=(
  "htop"
  "gcc"
  "gdb"
  "cpplint"
  "mdadm"
  "yt-dlp"
  "wine"
  "remmina"
  "gimp"
  "lmms"
  "dosbox"
  "libreoffice"
  "qbittorrent"
  "gparted"
  "qdirstat"
  "virtualbox"
  "virtualbox-guest-additions-iso"
  "steam"
)
for PROGRAM in "${APT_PROGRAMS[@]}"; do
  sudo apt install "$PROGRAM" -y
done

# VScode Install
wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install ./vscode.deb -y

# Flatpak Program Installs
FLATPAK_PROGRAMS=(
  "com.github.tchx84.Flatseal"
  "org.videolan.VLC"
  "com.google.Chrome"
  "com.usebottles.bottles"
  "org.audacityteam.Audacity"
  "org.openshot.OpenShot"
  "com.obsproject.Studio"
  "com.discordapp.Discord"
  "org.prismlauncher.PrismLauncher"
)
for PROGRAM in "${FLATPAK_PROGRAMS[@]}"; do
  flatpak install "$PROGRAM" -y
done

# Firmware Updates
# This only works with some hardware
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update

# Clean up
sudo apt autoremove -y
