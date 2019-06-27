#!/bin/bash
# Simple backup script using rsync
# syncs the users home folder to a mounted backup drive
#
# 1. iteration: rsync complete home folder
# 2. iteration OPTIONAL: iterates once more over the folder excluding listed directories but also deletes files in backup folder
#
# Created by
# Max Rossmannek
# 2018-02-21
#
# Usage: run ./large_backup.sh

rsync --log-file=/home/${USER}/.log_large_backup.txt --progress -av ~ /mnt/backup
notify-send -u low 'Backup' 'Please make a choice...'
read -p "Perform deletion step? (y/n)" choice
case "$choice" in
    y|Y ) echo "Starting..."; rsync --log-file=/home/${USER}/.log_del_large_backup.txt --progress -av --exclude=Backups --exclude=Music --exclude=Pictures --exclude=Videos --delete ~ /mnt/backup;;
    n|N ) echo "Skipping deletion step!"; echo "Done.";;
esac
