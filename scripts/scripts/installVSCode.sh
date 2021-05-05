#!/bin/bash

# import the GPG key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# write the repo file
sudo tee -a /etc/yum.repos.d/vscode.repo > /dev/null << 'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# install vscode
sudo yum install code



