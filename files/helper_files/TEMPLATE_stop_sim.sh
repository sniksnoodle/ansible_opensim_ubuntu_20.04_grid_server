#!/bin/bash

# change into bin directory
cd /home/opensim/opensim/bin

#stuff opensim backup command into running screen session
screen -r @@Monit Name@@ -p 0 -X stuff "backup $(printf '\r')"

# sleep for 15 seconds
sleep 15

#stuff shutdown command into running screen session
screen -r @@Monit Name@@ -p 0 -X stuff "shutdown $(printf '\r')"

# sleep for 15 seconds
sleep 30

#stuff exit command into running screen session to exit it
screen -r @@Monit Name@@ -p 0 -X stuff "exit $(printf '\r')"
