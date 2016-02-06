#!/bin/sh

set -o errexit
set -o nounset

pushd $(dirname $(readlink -f $0))

DIR=$(pwd)

# This file is only for Fedora!
NONE='\033[00m'
YELLOW='\033[01;33m'

# Add repositories
sudo rpm --import "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)" "http://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)"
echo -e "${YELLOW}Adding RPM Fusion repos ...${NONE}"
sudo dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo -e "${YELLOW}Adding Google Chrome repos ...${NONE}"
sudo cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub

## Adobe Flash
echo -e "${YELLOW}Adding Adobe repository ...${NONE}"
sudo rpm -Uvh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux

# Install basic tools
echo -e "${YELLOW}Installing tools ...${NONE}"
sudo dnf clean all
sudo dnf makecache
sudo dnf -y install zsh vim vim-X11 tmux screen irssi git mosh rpmdevtools yum-utils tree rsync \
  rxvt-unicode-256color-ml xclip \
  gnome-tweak-tool flash-plugin nspluginwrapper alsa-plugins-pulseaudio \
  ibus-table-chinese-quick anthy ibus-anthy google-chrome freetype-freeworld
sudo dnf -y remove PackageKit-command-not-found naver-nanum-gothic-fonts vlgothic-fonts

echo -e "${YELLOW}Installing Fedy ...${NONE}"
pushd /var/tmp
sudo curl http://folkswithhats.org/fedy-installer -o fedy-installer && sudo chmod +x fedy-installer && sudo ./fedy-installer
popd

# Disable middle click on thinkpad
echo -e "${YELLOW}Disabling middle click ...${NONE}"
if xinput | grep -i "dualpoint stick" > /dev/null 2>&1; then
  echo 'pointer = 1 10 3 4 5 6 7 8 9 2' >> $HOME/.Xmodmap	
fi

# Map menu key to win key
echo -e "${YELLOW}Mapping menu key to win key ...${NONE}"
if [ -e /usr/share/X11/xkb/symbols/pc ] && [ ! -e pc.bak ]; then
  cp /usr/share/X11/xkb/symbols/pc ./pc.bak
  sudo sed -i '/MENU/ s/Menu/Super_R/g' /usr/share/X11/xkb/symbols/pc
  # clear xkb cache
  sudo rm -rf /var/lib/xkb/*
fi

# Install powerline fonts
echo -e "${YELLOW}Installing powerline fonts ...${NONE}"
mkdir /var/tmp/$(basename $0)-$$ && cd /var/tmp/$(basename $0)-$$
git clone https://github.com/powerline/fonts.git && cd fonts
./install.sh
cd $DIR
rm -rf /var/tmp/$(basename $0)-$$
sudo rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf
fc-cache -fv

echo -e "${YELLOW}Reducing gnome titlebar height ...${NONE}"
cat << EOF >> $HOME/.config/gtk-3.0/gtk.css
.header-bar.default-decoration {
  padding-top: 3px;
  padding-bottom: 3px;
}

.header-bar.default-decoration .button.titlebutton {
  padding-top: 2px;
  padding-bottom: 2px;
}
EOF

# Generate SSH key

echo -e "${YELLOW}Generating SSH key ...${NONE}"
ssh-keygen -t rsa -b 4096

# add option 'noatime' to /etc/fstab

# screen color profile

# Finished
echo -e "${YELLOW}System setup finished! Please restart the computer.${NONE}"

popd
