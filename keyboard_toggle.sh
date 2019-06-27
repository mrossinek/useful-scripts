#!/bin/bash
# Script to toggle between different keyboard layouts
# Developed on Arch Linux using i3
#
# Created by
# Max Rossmannek
# 2018-02-21
#
# Usage: run ./keyboard_toggle.sh
# Optionally: bind this script to a keyboard shortcut

layout=$(setxkbmap -query | grep layout | awk '{print substr($0, length($0)-1)}')

if [ "$layout" == "de" ]; then
    setxkbmap us
else
    setxkbmap de
fi
