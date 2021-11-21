#!/bin/bash

left=~/.config/conky/conky_left.conf
right=~/.config/conky/right_side.conf

cd $(dirname $0)
killall conky 2>/dev/null

if [ "$1" = "-n" ] 
then
    pause_flag=""
else
    pause_flag="--pause=3"
    echo "Conky waiting 3 seconds to start..."
fi

if [[ -e $left ]] 
then
    conky --daemonize --quiet "$pause_flag" --config=$left
    conky --daemonize --quiet "$pause_flag" --config=$right
    echo "conky was started successfull!"
else 
    echo "conky was not started..."
    echo "check your conky's configuration files"
fi
