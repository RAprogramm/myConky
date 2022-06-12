#!/bin/bash

left=~/.config/conky/sides/conky_left.conf
right=~/.config/conky/sides/right_side.conf
clock_calendar=~/.config/conky/clock_calendar/clock_calendar.conf
weather=~/.config/conky/weather/weather.conf
player=~/.config/conky/player/player.conf

cd $(dirname $0)
killall conky

if [[ -e $left ]] 
then
    conky --daemonize --quiet --config=$left
    conky --daemonize --quiet --config=$right
    conky --daemonize --quiet --config=$clock_calendar
    conky --daemonize --quiet --config=$weather
    conky --daemonize --quiet --config=$player
    echo "conky was started successfull!"
else 
    echo "conky was not started..."
    echo "check your conky's configuration files"
fi
