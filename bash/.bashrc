#!/bin/bash

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi
