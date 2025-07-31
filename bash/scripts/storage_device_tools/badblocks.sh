#!/bin/sh
# Scan the disk for bad blocks using badblocks.

DEV=sda
sudo badblocks -so ~/badblocks.log /dev/$DEV && less ~/badblocks.log
