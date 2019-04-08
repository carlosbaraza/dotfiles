#!/bin/bash

curl https://ftp-master.debian.org/keys/archive-key-8.asc | gpg --dearmor > /tmp/debian-archive-key-8.gpg
sudo install -o root -g root -m 644 /tmp/debian-archive-key-8.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb http://ftp.be.debian.org/debian/ buster main contrib non-free" > /etc/apt/sources.list.d/sources.list'
rm /tmp/debian-archive-key-8.gpg