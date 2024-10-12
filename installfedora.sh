#!/bin/bash

###### Sudo

sudo sed -i 's/^#\s*\(%wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL\)/\1/' /etc/sudoers
sudo usermod -aG wheel "${USER}"


###### General update
sudo dnf -y update

####### Install rpm fusion
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

##### Install rpm sphere
sudo dnf -y install https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-38-1.noarch.rpm

###### Install Nvidia
##### Install devlopment software
sudo dnf -y install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig

sudo dnf -y update
sudo dnf -y makecache
sudo dnf -y install akmod-nvidia xorg-x11-drv-nvidia-cuda

###### Install VScode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

##### Create vscode.repo

sudo touch /etc/yum.repos.d/vscode.repo
sudo bash -c 'cat <<EOF> /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1\ngpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc"
EOF'

##### dnf update
sudo dnf -y check-update

##### Install the actual code editor
sudo dnf -y install code

#### Install code extensions
code -install-extension davidanson.vscode-markdownlint
code -install-extension esbenp.prettier-vscode
code -install-extension github.copilot
code -install-extension github.copilot-chat
code -install-extension keesschollaart.vscode-home-assistant
code -install-extension ms-azuretools.vscode-docker
code -install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code -install-extension ms-python.debugpy
code -install-extension ms-python.python
code -install-extension ms-python.vscode-pylance
code -install-extension ms-vscode.makefile-tools
code -install-extension ms-vscode.remote-explorer
code -install-extension ms-vscode-remote.remote-containers
code -install-extension ms-vscode-remote.remote-ssh
code -install-extension ms-vscode-remote.remote-ssh-edit
code -install-extension pkief.material-icon-theme
code -install-extension redhat.ansible
code -install-extension redhat.vscode-yaml
code -install-extension rust-lang.rust-analyzer
code -install-extension trunk.io
code -install-extension zainchen.json

#### Set the settings.json
install -d ~/.config/Code/User
sudo touch /~/.config/Code/User/settings.json
sudo bash -c 'cat <<EOF> ~/.config/Code/User/settings.json
{
    "workbench.colorTheme": "Monokai Dimmed",
    "workbench.iconTheme": "material-icon-theme",
    "workbench.editor.enablePreview": false,
    "redhat.telemetry.enabled": true,
    "files.exclude": {
        "**/.trunk/*actions/": true,
        "**/.trunk/*logs/": true,
        "**/.trunk/*notifications/": true,
        "**/.trunk/*out/": true,
        "**/.trunk/*plugins/": true
    },
    "trunk.trunkGrayOutNonBlockingIssues": false,
    "files.watcherExclude": {
        "**/.trunk/*actions/": true,
        "**/.trunk/*logs/": true,
        "**/.trunk/*notifications/": true,
        "**/.trunk/*out/": true,
        "**/.trunk/*plugins/": true
    },
    "vs-kubernetes": {
        "vscode-kubernetes.helm-path-linux": "~/.local/state/vs-kubernetes/tools/helm/linux-amd64/helm",
        "vscode-kubernetes.kubectl-path-linux": "~/.local/state/vs-kubernetes/tools/kubectl/kubectl",
        "vscode-kubernetes.minikube-path-linux": "~/.local/state/vs-kubernetes/tools/minikube/linux-amd64/minikube"
    },
    "terminal.explorerKind": "both",
    "terminal.external.linuxExec": "tilix",
    "terminal.sourceControlRepositoriesKind": "both",
    "terminal.integrated.automationProfile.linux": {},
    "git.confirmSync": false,
    "git.autofetch": true,
    "git.suggestSmartCommit": false,
    "editor.minimap.enabled": false,
    "editor.defaultFormatter": "trunk.io",
    "editor.fontFamily": "JetBrains Mono",
    "editor.fontSize": 13,
    "editor.fontLigatures": true,
    "editor.fontVariations": false
}
EOF'
###### End VScode

## gnome-shell-extensions
sudo dnf install gnome-extensions-app
sudo dnf install gnome-shell-extension-dash-to-dock

### Install Google Chrome
sudo dnf -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

### Install Mozilla Thunderbird
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
## Create empty repo file
sudo touch /etc/yum.repos.d/virtualbox.repo

## Populate the file
sudo bash -c 'cat <<EOF> /etc/yum.repos.d/virtualbox.repo
[virtualbox]
name=Fedora $releasever - $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/\$releasever/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox_2016.asc
EOF'

## Install the gpg key
sudo rpm --import https://www.virtualbox.org/download/oracle_vbox_2016.asc

## Install the Virtualbox rpm(s)
sudo dnf -y install VirtualBox
https://download.virtualbox.org/virtualbox/7.0.20/Oracle_VM_VirtualBox_Extension_Pack-7.0.20.vbox-extpack

## Activate Virtualbox
sudo akmods
sudo systemctl restart vboxdrv.service

### Install printer software
sudo dnf -y install hplip-gui
echo "Configure oa via CUPS!"

### Nordvpn
nordvpnurl="https://downloads.nordcdn.com/apps/linux/install.sh"
sudo sh <(curl -sSf ${nordvpnurl})
sudo usermod -aG nordvpn "${USER}"

### Generic
sudo dnf -y install vim bash-completion

### Reboot laptop
sudo reboot
