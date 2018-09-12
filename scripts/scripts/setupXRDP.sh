#!/bin/bash

sudo yum groupinstall -y "X Window System"
sudo yum groupinstall -y "Desktop Fonts"
sudo yum install -y gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts

sudo yum groupinstall -y "General Purpose Desktop"
sudo yum groupinstall -y --skip-broken "GNOME Desktop"

sudo yum install -y firefox

sudo yum install -y xrdp

sudo chkconfig --levels 5 xrdp on

sudo ln -sf /lib/systemd/system/graphical.target /etc/systemd/system/default.target

