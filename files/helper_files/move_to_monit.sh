#!/bin/bash

/bin/mv *.conf /etc/monit/conf.d/
/usr/bin/monit reload
/bin/rm move_to_monit.sh
