#!/bin/bash

cd ~/dotfiles

rm -rf ~/.git*
stow git

rm -rf ~/scripts
stow scripts

rm -rf ~/.bash*
stow bash
. ~/.bashrc

if [ -e /data ]; then
 echo "Data directory exists.  linking dirs"
 ln -s /data/apps ~/apps
 ln -s /data/dev  ~/dev
 ln -s /data/.gradle ~/.gradle
 ln -s /data/.m2 ~/.m2
 if [ -e ~/Downloads ]; then
    rm -rf ~/Downloads
 fi
 ln -s /data/Downloads ~/Downloads
fi
