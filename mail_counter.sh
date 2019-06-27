#!/bin/sh
# script to count unread mail in users .mail directory
#
# Created by
# Max Rossmannek
# 2018-08-10
#
# Usage: run ./mail_counter.sh
# Note: it ignores mails in folders pointing to trash, deleted items or drafts

find ~/.mail -type d -name "new" -exec sh -c '
        for dir do
                if echo $dir | grep -viq "trash\|del\|draft"; then
                        count=$(( $count + $(ls -l "$dir" | egrep -c '^-') ))
                fi
        done
        echo $count
' sh {} +
