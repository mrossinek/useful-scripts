#!/bin/bash
# SD card mounting script for linux
#
# Created by
# Max Rossmannek
# 2018-02-21
#
# Usage: run ./card_mount.sh /dev/mmcblk*
# and replace mmcblk* with the corresponding device name

sudo mount -t vfat -o gid=$USER,fmask=113,dmask=002 $1 /mnt/card
