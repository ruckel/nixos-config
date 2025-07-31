#!/bin/sh
# Check the filesystem

FS=sda1
sudo -A fsck -N /dev/$FS
