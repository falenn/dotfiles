#!/bin/bash

if [ /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ ~/.bash_profile ]; then
  . ~/.bash_profile
fi
