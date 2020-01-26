#!/bin/bash
# Small backup script involving a FAT drive
#
# 1. iteration: performs backup
# 2. iteration OPTIONAL: also performs delete changes
#
# Created by
# Max Rossmannek
# 2018-02-21
#
# Usage: run ./small_backup.sh

rsync --log-file=/home/${USER}/.log_small_backup.txt --progress -av --modify-window=1 ~/Files /mnt/stick
notify-send -i media-flash -u low 'Backup' 'Please make a choice...'
read -p "Perform deletion step? (y/n)" choice
case "$choice" in
    y|Y ) echo "Starting..."; rsync --log-file=/home/${USER}/.log_del_small_backup.txt --progress -av --modify-window=1 --existing --ignore-existing --delete ~/Files /mnt/stick;;
    n|N ) echo "Skipping deletion step!"; echo "Done.";;
esac
