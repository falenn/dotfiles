#!/bin/bash

check=`which stow`
if [[ $? -gt 0 ]]; then
  sudo yum install stow -y
fi

if [[ $? -eq 0 ]]; then 
  cd ~/dotfiles

  rm -rf ~/.git*
  stow git

  rm -rf ~/scripts
  stow scripts

  rm -rf ~/.bash*
  stow bash
  . ~/.bashrc

  rm -rf ~/.tmux.conf
  stow tmux

  if [ -d "/data" ]; then
   echo "Data directory exists.  linking dirs"
   ln -s /data/apps ~/apps
   ln -s /data/dev  ~/dev
   ln -s /data/.gradle ~/.gradle
   ln -s /data/.m2 ~/.m2
   if [ -d "~/Downloads" ]; then
     rm -rf ~/Downloads
   fi
   ln -s /data/Downloads ~/Downloads
  fi
else
  echo "Unable to install stow."
fi
