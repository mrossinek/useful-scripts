#!/bin/sh
# script to watch latest stock prices via alphavantage.co
#
# Created by
# Max Rossmannek
# 2018-09-13
#
# Usage: run ./stock_watcher.sh
# Config:
#   apikey.txt:  holds your private apikey as a string on a single line
#   library.txt: holds one Yahoo Finance symbol and a name per line
#   prices.txt:  will hold the latest stock prices

padlength=$(echo "Last updated `date`" | wc -c)
pad=$(printf '%0.s_' `seq 1 ${padlength}`)

apikey="./apikey.txt"
apikey=$(cat $apikey)
library="./library.txt"
output="./prices.txt"
tmp_copy="./tmp.txt"

rm -f $tmp_copy
touch $tmp_copy

while read stock; do
        IFS=" " read sym name <<< $stock
        price=$(curl -s 'https://www.alphavantage.co/query?apikey='${apikey}'&function=TIME_SERIES_DAILY&symbol='${sym} | jq -r '[."Time Series (Daily)"[]][0]."4. close"')
        printf '%s%*.*s%s\n' "${name}" 0 $(( ${padlength} - ${#name} - ${#price} - 1 )) "${pad}" "${price}" >> $tmp_copy
        sleep 20  # do not exceed limit of 5 api calls per minute
done <$library

echo >> $tmp_copy
echo "Last updated `date`" >> $tmp_copy

cp $tmp_copy $output
rm $tmp_copy
