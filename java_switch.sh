#!/bin/bash
# script to switch java-runtime version
#
# Created by
# Max Rossmannek
# 2018-07-02
#
# Usage: run ./java_switch.sh
# Note: siwtches between Java 8 and 9 ONLY

current_version=$(sudo ls -l /usr/lib/jvm/default | grep -o "[0-9]" | tail -1)
new_version=$([[ $current_version = 8 ]] && echo "10" || echo "8")

sudo \rm /usr/lib/jvm/default
sudo \rm /usr/lib/jvm/default-runtime

sudo ln -s /usr/lib/jvm/java-$new_version-openjdk /usr/lib/jvm/default
sudo ln -s /usr/lib/jvm/java-$new_version-openjdk /usr/lib/jvm/default-runtime

