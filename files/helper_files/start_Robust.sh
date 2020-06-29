#!/bin/bash

# change into bin directory
cd /home/opensim/opensim/bin

# Here we add checks for any dead screen sessions

DEADSCREENS=$(pstree -s -g opensim | grep -v mono | grep screen | cut -d'(' -s -f2 | cut -d')' -s -f1 | xargs echo )

# assign screens without mono running to array

array=( $DEADSCREENS  )

# iterate through array and kill selected screens
for i in "${array[@]}"
do
kill "${array[@]}"
done

#start detached names screen session for sim
screen -d -m -S Robust

#stuff opensim  start command into running screen session
screen -r Robust -p 0 -X stuff "mono Robust.exe -inifile=\"Robust.HG.ini\" $(printf '\r')"

