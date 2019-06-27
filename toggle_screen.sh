#!/bin/bash
# Script to toggle external screens connected via HDMI or DP
# Developed on Arch Linux using i3
#
# Created by
# Max Rossmannek
# 2018-02-21
#
# Usage: run ./toogle_screen.sh
# Optionally: bind this script to a keyboard shortcut

numberConnected=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | wc -l)
numberActive=$(xrandr | grep -E " connected (primary )?[0-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | wc -l)


if (($numberConnected > $numberActive)); then
    echo "Turning inactive screens on..."
    if xrandr | grep "HDMI2 connected"; then
        xrandr --output HDMI2 --auto --scale 1.33x1.33 --right-of eDP1 --auto
    elif xrandr | grep "DP1 connected"; then
        xrandr --output DP1 --auto --right-of eDP1 --auto
    else
        echo "Error."
    fi
elif (($numberConnected == $numberActive)); then
    echo "Turning external screens off..."
    if xrandr | grep "HDMI2 connected"; then
        xrandr --output HDMI2 --off --output eDP1 --auto
    elif xrandr | grep "DP1 connected"; then
        xrandr --output DP1 --off --output eDP1 --auto
    else
        echo "Error."
    fi
else
    echo "You cannot have more active than connected screens!"
fi
