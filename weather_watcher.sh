#!/bin/bash
# script to watch current and forecast weather from accuweather.com
#
# Created by
# Max Rossmannek
# 2020-05-13
#
# Usage: run ./weather_watcher.sh
# Config:
#   loccode.txt:  holds the location code on the first line of the file

# map accuweather icon indices to unicode characters of Weather Icons font
declare -A accuweather_icon_map=(
    ["01"]="" # Sunny                     : wi-day-sunny           : \uF00D
    ["02"]="" # Mostly Sunny              : wi-day-cloudy          : \uF002
    ["03"]="" # Partly Sunny              : wi-day-cloudy          : \uF002
    ["04"]="" # Intermittent Clouds       : wi-day-sunny-overcast  : \uF00C
    ["05"]="" # Hazy Sunshine             : wi-day-haze            : \uF0B6
    ["06"]="" # Mostly Cloudy             : wi-day-cloudy          : \uF002
    ["07"]="" # Cloudy                    : wi-cloudy              : \uF013
    ["08"]="" # Dreary (Overcast)         : wi-cloud               : \uF041
    ["11"]="" # Fog                       : wi-fog                 : \uF014
    ["12"]="" # Showers                   : wi-showers             : \uF01A
    ["13"]="" # Mostly Cloudy w/ Showers  : wi-day-showers         : \uF009
    ["14"]="" # Partly Sunny w/ Showers   : wi-day-rain            : \uF008
    ["15"]="" # T-Storms                  : wi-thunderstorm        : \uF01E
    ["16"]="" # Mostly Cloudy w/ T-Storms : wi-day-storm-showers   : \uF00E
    ["17"]="" # Partly Sunny w/ T-Storms  : wi-day-thunderstorm    : \uF010
    ["18"]="" # Rain                      : wi-rain                : \uF019
    ["19"]="" # Flurries                  : wi-cloudy-gusts        : \uF011
    ["20"]="" # Mostly Cloudy w/ Flurries : wi-day-cloudy-windy    : \uF001
    ["21"]="" # Partly Sunny w/ Flurries  : wi-day-cloudy-gust     : \uF000
    ["22"]="" # Snow                      : wi-snow                : \uF01B
    ["23"]="" # Mostly Cloudy w/ Snow     : wi-day-snow            : \uF00A
    ["24"]="" # Ice                       : wi-snowflake-cold      : \uF076
    ["25"]="" # Sleet                     : wi-sleet               : \uF0B5
    ["26"]="" # Freezing Rain             : wi-rain-mix            : \uF017
    ["29"]="" # Rain and Snow             : wi-rain-mix            : \uF017
    ["30"]="" # Hot                       : wi-hot                 : \uF072
    ["31"]="" # Cold                      : wi-snowflake-cold      : \uF076
    ["32"]="" # Windy                     : wi-windy               : \uF021
    ["33"]="" # Clear                     : wi-night-clear         : \uF02e
    ["34"]="" # Mostly Clear              : wi-night-partly-cloudy : \uF083
    ["35"]="" # Partly Cloudy             : wi-night-cloudy        : \uF031
    ["36"]="" # Intermittent Clouds       : wi-night-partly-cloudy : \uF083
    ["37"]="" # Hazy Moonlight            : wi-night-fog           : \uF04A
    ["38"]="" # Mostly Cloudy             : wi-night-cloudy        : \uF031
    ["39"]="" # Partly Cloudy w/ Showers  : wi-night-showers       : \uF037
    ["40"]="" # Mostly Cloudy w/ Showers  : wi-night-rain          : \uF036
    ["41"]="" # Partly Cloudy w/ T-Storms : wi-night-storm-showers : \uF03A
    ["42"]="" # Mostly Cloudy w/ T-Storms : wi-night-thunderstorm  : \uF03B
    ["43"]="" # Mostly Cloudy w/ Flurries : wi-night-cloudy-windy  : \uF030
    ["44"]="" # Mostly Cloudy w/ Snow     : wi-night-snow          : \uF038
)

loccode="$HOME/.weather/loccode.txt"
loccode=$(head -n 1 "$loccode")
output="$HOME/.weather/weather.txt"
tmp_copy="$HOME/.weather/tmp.txt"

rm -f "$tmp_copy"
touch "$tmp_copy"

rss=$(curl -s http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1\&locCode="${loccode}")

pubdate=$(echo "${rss}" | grep -oP '<pubDate>\K[^<]*(?=</pubDate>)' -m 1)

descriptions=$(echo "${rss//[$'\t\r\n']}" | grep -oE '<description>[^\"]*\"http[^<]*</description>')

count=0
while read -r desc; do
    temps=$(echo "${desc}" | grep -oP '<description>\K.*(?=\&lt;img)' | grep -oP '\s\K\d+')
    icon=$(echo "${desc}" | grep -oP 'icons/\K\d+[^_]')
    echo "$(eval date -d \"+${count} days\" +\"%d %b\");${accuweather_icon_map[$icon]};${temps/[$'\t\r\n']/;}" >> "$tmp_copy"
    count=$((count+1))
done <<< "${descriptions}"

date -d "${pubdate}" >> "$tmp_copy"

cp "$tmp_copy" "$output"
