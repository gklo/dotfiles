#!/bin/sh
DEFAULTPROF=`dconf list /org/gnome/terminal/legacy/profiles:/`
dconf write /org/gnome/terminal/legacy/profiles:/${DEFAULTPROF}cursor-shape "'$1'"
