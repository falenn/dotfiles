#!/bin/bash


# Needs epel
sudo yum install epel-release

# install snap
sudo yum install snapd

sudo systemctl enable --now snapd.socket

sudo ln -s /var/lib/snapd/snap /snap

sudo snap install -y k9s

# https://snapcraft.io/k9s

