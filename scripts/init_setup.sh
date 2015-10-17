#!/bin/sh

set -o errexit
set -o nounset

pushd $(dirname $(readlink -f $0))
{
  exec 2>&1 

  DIR=$(pwd)

  # This file is only for Fedora!

  # Add repositories
  ## Adobe Flash
  echo "Adding Adobe repository ..."
  sudo rpm -Uvh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
  sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux

  # Install basic tools
  echo "Installing tools ..."
  sudo dnf clean all
  sudo dnf makecache
  sudo dnf -y install zsh vim vim-X11 tmux screen irssi git mosh rpmdevtools yum-utils tree rsync \
    rxvt-unicode-256color-ml xclip \
    gnome-tweak-tool flash-plugin nspluginwrapper alsa-plugins-pulseaudio \
    ibus-table-chinese-quick anthy ibus-anthy
  sudo dnf -y remove PackageKit-command-not-found naver-nanum-gothic-fonts vlgothic-fonts

  # Disable middle click on thinkpad
  echo "Disabling middle click ..."
  if xinput | grep -i "dualpoint stick" > /dev/null 2>&1; then
    echo 'pointer = 1 10 3 4 5 6 7 8 9 2' >> $HOME/.Xmodmap	
  fi

  # Map menu key to win key
  echo "Mapping menu key to win key ..."
  if [ -e /usr/share/X11/xkb/symbols/pc ] && [ ! -e pc.bak ]; then
    cp /usr/share/X11/xkb/symbols/pc ./pc.bak
    sudo sed -i '/MENU/ s/Menu/Super_R/g' /usr/share/X11/xkb/symbols/pc
    # clear xkb cache
    sudo rm -rf /var/lib/xkb/*
  fi

  # Install powerline fonts
  echo "Installing powerline fonts ..."
  mkdir /var/tmp/$(basename $0)-$$ && cd /var/tmp/$(basename $0)-$$
  git clone https://github.com/powerline/fonts.git && cd fonts
  ./install.sh
  cd $DIR
  rm -rf /var/tmp/$(basename $0)-$$
  sudo rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf
  fc-cache -fv

  echo "Reducing gnome titlebar height ..."
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
echo "Generating SSH key ..."
ssh-keygen -t rsa -b 4096

# add option 'noatime' to /etc/fstab

# screen color profile

# Finished
echo "System setup finished! Please restart the computer."
} | cat -v | tee init_setup.log 

popd
