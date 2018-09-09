#!/bin/bash

cd ~/dotfiles

rm -rf ~/.bash*

stow bash
. ~/.bash_profile

rm -rf ~/.git*
stow git

rm -rf ~/scripts
stow scripts
