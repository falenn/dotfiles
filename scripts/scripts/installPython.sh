#!/usr/bin/env bash

PYTHON_VERSION=3.9.6


sudo yum install -y epel-release

sudo yum install -y git gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel


git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

echo "Add export PYENV_ROOT=$HOME/.pyenv to your .bash_profile and add $PYENV_ROOT/bin to your path" 

## pyenv
~/.pyenv/bin/pyenv install $PYTHON_VERSION

~/.pyenv/bin/pyenv version

~/.pyenv/bin/pyenv global $PYTHON_VERSION


