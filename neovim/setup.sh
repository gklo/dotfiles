#!/bin/bash

if [[ -e ~/.config/nvim ]]; then
    mv ~/.config/nvim ~/.config/nvim_bak
    mkdir ~/.config/nvim
    mkdir ~/.config/nvim/undo
fi

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp init.vim ~/.config/nvim

pip3 install --user pynvim

nvim +PlugInstall +qall
