#!/bin/bash
# USB mounting script for linux
#
# Created by
# Max Rossmannek
# 2018-02-21
#
# Usage: run ./usb_mount.sh /dev/sd**
# and replace sd** with the corresponding device name

sudo mount -o gid=$USER,fmask=113,dmask=002 $1 /mnt/usb
notify-send -i media-removable -u low 'USB' "A new USB device was mounted on $1"
