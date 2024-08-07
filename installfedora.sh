#!/bin/bash

### General update
dnf -y update

### Install rpm fusion 
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## Install rpm sphere
sudo dnf -y install https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-38-1.noarch.rpm

### Install Nvidia
## Install devlopment software
sudo dnf -y install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig

sudo dnf -y update
sudo dnf -y makecache
sudo dnf -y install akmod-nvidia xorg-x11-drv-nvidia-cuda

### Install vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

## Create vscode.repo 
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# dnf shit
sudo dnf -y check-update

# Install the actual code editor
sudo dnf -y install code

# Install code extensions
code -install-extension sbenp.prettier-vscode
code -install-extension keesschollaart.vscode-home-assistant
code -install-extension ms-azuretools.vscode-docker
code -install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code -install-extension ms-python.debugpy
code -install-extension ms-python.python
code -install-extension ms-python.vscode-pylance
code -install-extension ms-vscode-remote.remote-containers
code -install-extension ms-vscode-remote.remote-ssh
code -install-extension ms-vscode-remote.remote-ssh-edit
code -install-extension ms-vscode.remote-explorer
code -install-extension pkief.material-icon-theme
code -install-extension redhat.ansible
code -install-extension redhat.vscode-yaml
code -install-extension rust-lang.rust-analyzer
code -install-extension trunk.io
code -install-extension zainchen.json

## gnome-shell-extensions
sudo dnf install gnome-extensions-app
sudo dnf install gnome-shell-extension-dash-to-dock

### Install Google Chrome
sudo dnf -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

### Install Mozilla Thuderbird
sudo dnf -y install thunderbird

### Install VLC
sudo dnf -y install vlc

### Install Audacity
sudo dnf -y install audacity

### Balena Echer
sudo dnf -y install https://github.com/balena-io/etcher/releases/download/v1.19.21/balena-etcher-1.19.21-1.x86_64.rpm

### Install asusctl
sudo dnf -y install asusctl
sudo dnf -y install asusctl-rog-gui

systemctl start asusd

### Install Vagrant
sudo dnf -y install vagrant

### Install VirtualBox
sudo touch /etc/yum.repos.d/virtualbox.repo
sudo bash -c 'cat <<EOF>> /etc/yum.repos.d/virtualbox.repo
[virtualbox]
name=Fedora $releasever - $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/$releasever/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox_2016.asc
EOF'

sudo rpm --import https://www.virtualbox.org/download/oracle_vbox_2016.asc
sudo dnf -y install VirtualBox
sudo akmods
sudo systemctl restart vboxdrv.service

### Install printer software
sudo dnf -y install hplip-gui
echo "Configure oa via CUPS!"

### Reboot laptop
sudo reboot

