#!/bin/sh

pushd $(dirname $(readlink -f $0))/..

git submodule init
git submodule update

# fontconfig settings
[ ! -d $HOME/.config/fontconfig ] && mkdir $HOME/.config/fontconfig
ln -s $(readlink -f fontconfig/fonts.conf) $HOME/.config/fontconfig/fonts.conf

# tmux settings
[ -e $HOME/.tmux.conf ] && mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
ln -s $(readlink -f tmux/tmux.conf) $HOME/.tmux.conf

# urxvt/rxvt-unicode settings
[ -d $HOME/.urxvt ] && mv $HOME/.urxvt $HOME/.urxvt.bak
ln -s $(readlink -f urxvt) $HOME/.urxvt
ln -s $HOME/.urxvt/Xresources $HOME/.Xresources
xrdb $HOME/.Xresources

# vim settings
[ -d $HOME/.vim ] && mv $HOME/.vim $HOME/.vim.bak
ln -s $(readlink -f vim) $HOME/.vim
echo "Please run 'make' in vim/plugged/vimproc.vim to create vimproc module for vim"

# Gnome Terminal settings
DEFAULTPROF=`dconf list /org/gnome/terminal/legacy/profiles:/`
dconf write /org/gnome/terminal/legacy/profiles:/${DEFAULTPROF}font "'Terminess Powerline 14'"
# custom color palette
dconf write /org/gnome/terminal/legacy/profiles:/${DEFAULTPROF}palette "'[\'rgb(34,34,34)\', \'rgb(249,38,114)\', \'rgb(0,205,0)\', \'rgb(253,151,31)\', \'rgb(70,130,180)\', \'rgb(174,129,255)\', \'rgb(137,182,226)\', \'rgb(255,255,255)\', \'rgb(69,69,69)\', \'rgb(249,38,114)\', \'rgb(0,255,0)\', \'rgb(253,151,31)\', \'rgb(70,130,180)\', \'rgb(174,129,255)\', \'rgb(70,164,255)\', \'rgb(255,255,255)\']'"
# unlimited scrollback buffer
dconf write /org/gnome/terminal/legacy/profiles:/${DEFAULTPROF}scrollback-unlimited true
# hide scrollbar
dconf write /org/gnome/terminal/legacy/profiles:/${DEFAULTPROF}scrollbar-policy "'never'"
# hide menubar
dconf write /org/gnome/terminal/legacy/default-show-menubar false

popd
