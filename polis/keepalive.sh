#!/bin/bash
# makerun.sh
# Version: 2018.02.24
# Add the following to the crontab (i.e. crontab -e)
# */5 * * * * ~/keepalive.sh

process=polisd
makerun="polisd"

if ps ax | grep -v grep | grep $process > /dev/null || [ -f ~/MAINTENANCE ]
then
    exit
else
    $makerun &
fi
