#!/bin/bash

cd /tmp

wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel-release-latest-*.noarch.rpm
