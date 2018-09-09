#!/bin/bash

cd ~/dotfiles

rm -rf ~/.git*
stow git

rm -rf ~/scripts
stow scripts

rm -rf ~/.bash*
stow bash
. ~/.bash_profile
