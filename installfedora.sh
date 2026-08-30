#!/bin/bash

###### Sudo
function enable_sudo(){
  sudo sed -i 's/^#\s*\(%wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL\)/\1/' /etc/sudoers
  sudo usermod -aG wheel "${USER}"
}

###### General update
function dnf_update_all(){
  sudo dnf -y install vim bash-completion
  sudo dnf -y update
}

####### Install rpm fusion
function install_rpmfusion(){
  sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

##### Install rpm sphere
function install_rpmsphere(){
  sudo touch /etc/yum.repos.d/rpmsphere-noarch.repo
  sudo bash -c 'cat <<EOF> /etc/yum.repos.d/rpmsphere-noarch.repo
[rpmsphere-noarch]
name=RPM Sphere - Noarch
baseurl=https://github.com/rpmsphere/noarch/raw/master/
skip_if_unavailable=True
gpgcheck=0
enabled=1
EOF'

  # Install rpm
  sudo dnf -y install rpmsphere-release
}

###### Install Nvidia
##### Install devlopment software
function install_nvidia(){
  sudo dnf -y install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
  sudo dnf -y update
  sudo dnf -y makecache
  sudo dnf -y install akmod-nvidia-580xx xorg-x11-drv-nvidia-580xx-cuda
}

#### Install asus-linux for Fedora
function install_asus_keyboard(){
  # https://asus-linux.org/guides/fedora-guide/
  sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
  #
  sudo dnf install asusctl
  # Enable and start the systemd service:
  systemctl enable --now asusd.service
  #To avoid problems with tuned, you should use ppd.
  sudo dnf swap tuned-ppd power-profiles-daemon --allowerasing
  systemctl enable --now power-profiles-daemon.service
  # ROG Control Center is a GUI tool that can be used to configure asusctl. 
  # After adding the Terra or COPR repository as described above, you can now install the tool:
  sudo dnf install asusctl-rog-gui

}

###### Install VScode
function install_vscode(){
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

  # Create vscode.repo
  sudo touch /etc/yum.repos.d/vscode.repo
  sudo bash -c 'cat <<EOF> /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1\ngpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc"
EOF'

  # dnf update
  sudo dnf -y check-update

  # Install the actual code editor
  sudo dnf -y install code

  #### Install code extensions
  # code -install-extension davidanson.vscode-markdownlint
  # code -install-extension esbenp.prettier-vscode
  # code -install-extension github.copilot
  # code -install-extension github.copilot-chat
  # code -install-extension keesschollaart.vscode-home-assistant
  # code -install-extension ms-azuretools.vscode-docker
  # code -install-extension ms-kubernetes-tools.vscode-kubernetes-tools
  # code -install-extension ms-python.debugpy
  # code -install-extension ms-python.python
  # code -install-extension ms-python.vscode-pylance
  # code -install-extension ms-vscode.makefile-tools
  # code -install-extension ms-vscode.remote-explorer
  # code -install-extension ms-vscode-remote.remote-containers
  # code -install-extension ms-vscode-remote.remote-ssh
  # code -install-extension ms-vscode-remote.remote-ssh-edit
  # code -install-extension pkief.material-icon-theme
  # code -install-extension redhat.ansible
  # code -install-extension redhat.vscode-yaml
  # code -install-extension rust-lang.rust-analyzer
  # code -install-extension trunk.io
  # code -install-extension zainchen.json

  # Set the settings.json
  # install -d ~/.config/Code/User
  # sudo touch /~/.config/Code/User/settings.json
  # sudo bash -c 'cat <<EOF> ~/.config/Code/User/settings.json
# {
#     "workbench.colorTheme": "Monokai Dimmed",
#     "workbench.iconTheme": "material-icon-theme",
#     "workbench.editor.enablePreview": false,
#     "redhat.telemetry.enabled": true,
#     "files.exclude": {
#         "**/.trunk/*actions/": true,
#         "**/.trunk/*logs/": true,
#         "**/.trunk/*notifications/": true,
#         "**/.trunk/*out/": true,
#         "**/.trunk/*plugins/": true
#     },
#     "trunk.trunkGrayOutNonBlockingIssues": false,
#     "files.watcherExclude": {
#         "**/.trunk/*actions/": true,
#         "**/.trunk/*logs/": true,
#         "**/.trunk/*notifications/": true,
#         "**/.trunk/*out/": true,
#         "**/.trunk/*plugins/": true
#     },
#     "vs-kubernetes": {
#         "vscode-kubernetes.helm-path-linux": "~/.local/state/vs-kubernetes/tools/helm/linux-amd64/helm",
#         "vscode-kubernetes.kubectl-path-linux": "~/.local/state/vs-kubernetes/tools/kubectl/kubectl",
#         "vscode-kubernetes.minikube-path-linux": "~/.local/state/vs-kubernetes/tools/minikube/linux-amd64/minikube"
#     },
#     "terminal.explorerKind": "both",
#     "terminal.external.linuxExec": "tilix",
#     "terminal.sourceControlRepositoriesKind": "both",
#     "terminal.integrated.automationProfile.linux": {},
#     "git.confirmSync": false,
#     "git.autofetch": true,
#     "git.suggestSmartCommit": false,
#     "editor.minimap.enabled": false,
#     "editor.defaultFormatter": "trunk.io",
#     "editor.fontFamily": "JetBrains Mono",
#     "editor.fontSize": 13,
#     "editor.fontLigatures": true,
#     "editor.fontVariations": false
# }
# EOF'
}

##### gnome-shell-extensions
function install_gnome_extensions(){
  sudo dnf -y install gnome-extensions-app
  sudo dnf -y install gnome-shell-extension-dash-to-panel
  sudo dnf -y install gnome-tweaks

  for extension in $(gnome-extensions list); do
    echo "gnome-extensions enable $extension"
    gnome-extensions enable $extension
  done  

}

###### Install Google Chrome
function install_google_chrome(){
  sudo dnf -y install fedora-workstation-repositories
  sudo dnf config-manager setopt google-chrome.enabled=1
  sudo dnf -y install google-chrome-stable
}

###### Install Mozilla Thunderbird
function install_thunderbird(){
  sudo dnf -y install thunderbird
}

###### Install VLC
function install_vlc(){
  sudo dnf -y install vlc
}

###### Install Audacity
function install_audacity(){
  sudo dnf -y install audacity
}

###### Balena Etcher
function install_balena_etcher(){
  $ Variables
  latest_etcher_tag=$(git ls-remote --tags  https://github.com/balena-io/etcher|awk {'print$2'}|cut -d/ -f3|sort -V|tail -2|head -1|sed 's/^v\(.*\)/\1/') # 1.19.25^{}
  # Install latest Etcher
  sudo dnf -y install https://github.com/balena-io/etcher/releases/download/v${latest_etcher_tag}/balena-etcher-${latest_etcher_tag}-1.x86_64.rpm
}

###### Install asusctl
function install_asusctl(){
  sudo dnf -y install asusctl
  sudo dnf -y install asusctl-rog-gui

  systemctl enable asusd
  systemctl start asusd
}

##### Install Vagrant
function install_vagrant(){
wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo
sudo dnf -y install vagrant
}

##### Install VirtualBox
function install_virtualbox(){
  # Install esential packages
  sudo dnf -y install kernel-devel kernel-headers gcc make perl elfutils-libelf-devel

  # Download Virtualbox  repo file
  sudo curl -o /etc/yum.repos.d/virtualbox.test http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo

  # Install the gpg key
  sudo rpm --import https://www.virtualbox.org/download/oracle_vbox_2016.asc

  # Install the Virtualbox rpm(s)
  sudo dnf -y install VirtualBox

  # Add user to vboxusers group
  sudo usermod -a -G vboxusers ${USER}

  # Configuree VirtualBox Drivers
  #sudo /usr/lib/virtualbox/vboxdrv.sh setup
  #sudo /sbin/vboxconfig

  virtualbox_download="~/Download/virtualbox"
  virtualbox_version=$(rpm -qa --qf "%{NAME}:%{VERSION}\n" | grep -e '^VirtualBox-'|cut -d: -f2|sort -ui)
  virtualbox_latest=$(curl -s https://download.virtualbox.org/virtualbox/LATEST.TXT)
  virtualbox_extpack="Oracle_VM_VirtualBox_Extension_Pack-${virtualbox_version}.vbox-extpack"
  virtualbox_url="https://download.virtualbox.org/virtualbox/${virtualbox_version}/"
  
  # Make sure download subdir is present
  install -d ${virtualbox_download}

  cd ${virtualbox_download}
  wget "${virtualbox_url}/${virtualbox_extpack}"

  # Install Extension pack
  sudo echo "y" | VBoxManage extpack install --replace --accept-license=sha256 ${virtualbox_download}/${virtualbox_extpack}

  ## Activate Virtualbox
  sudo akmods --force
  sudo systemctl restart vboxdrv.service
}

### Install printer software
function install_hplip(){
  sudo dnf -y install hplip-gui
  echo "Configure oa via CUPS!"
}

### Nordvpn
function install_nordvpn(){
  nordvpnurl="https://downloads.nordcdn.com/apps/linux/install.sh"
  sudo sh <(curl -sSf ${nordvpnurl})
  sudo usermod -aG nordvpn "${USER}"
}

### Rclone
function install_rclone(){
  sudo dnf -y install rclone fuse
  install -d ~/gdrive
  rclone config


  # Create systemd user subdir
  install -d ~/.config/systemd/user

  # Create systemd file for automatic rclone of Google Drive.
  cat <<EOF > ~/.config/systemd/user/rclone-gdrive.service
[Unit]
Description=Rclone Google Drive (rclone-gdrive)
AssertPathIsDirectory=/home/${USER}/gdrive
After=network-online.target

[Service]
Type=simple
User=${USER}
Group=${USER}
ExecStart=/usr/bin/rclone mount \
  --config=/home/${USER}/.config/rclone/rclone.conf \
  --allow-other \
  --vfs-cache-mode=full \
  gdrive: /home/${USER}/gdrive
ExecStop=/bin/fusermount -uz /home/${USER}/gdrive
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

  #
  sudo cat <<EOF > /etc/fuse.conf
# mount_max = 1000
user_allow_other
EOF

  #
  systemctl --user daemon-reload
  systemctl --user enable rclone-gdrive.service
  systemctl --user start rclone-gdrive.service
  loginctl enable-linger $USER 
}

### Browser Brave
function install_brave(){
  sudo dnf -y install dnf-plugins-core
  sudo dnf -y config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  sudo dnf -y install brave-browser
}


function install_my_zshi(){
  echo "Install My ZSH"

}


function main(){
  enable_sudo
  dnf_update_all
  install_asus_keyboard
  install_rpmsphere
  install_rpmfusion
  install_nvidia
  install_vscode
  install_gnome_extensions
  install_google_chrome
  install_brave


}

## Main
main

### Reboot laptop
#sudo reboot
