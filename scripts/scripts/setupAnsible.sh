#!/bin/bash

# Install python3 first


sudo yum install -y yum-utils
sudo yum install -y groupinstall development
sudo yum install -y epel-release

sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y install python36
python3.6 -V

# Swap symlink
sudo rm -f /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python


sudo yum -y install python-pip

sudo pip install  --upgrade pip

# Jinja2: A modern and designer friendly templating language for Python.
#PyYAML: A YAML parser and emitter for the Python programming language.
#parmiko: Native Python SSHv2 protocol library.
#httplib2: A comprehensive HTTP client library.
#Most of the actions listed in this post are written with the assumption that they will be executed by the root user running the bash or any other modern shell.

sudo pip install jinja2 pyyaml paramiko httplib2
sudo pip install ansible

#Swap back
sudo rm -f /usr/bin/python
sudo ln -s /usr/bin/python2 /usr/bin/python
