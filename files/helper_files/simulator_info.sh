#!/bin/bash

# clear screen
echo -e '\0033\0143'

#define ANSI escape codes for colourisation
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[1;33m'
Default='\033[0m'

# display header

echo -e "${Yellow} **************************************************************"
echo -e " *                                                            *"
echo -e " *      simulator info.sh - version 00.1 - 1st May 2016       *"
echo -e " *      simulator info.sh - version 00.2 - 2nd Feb 2017       *"
echo -e " *                                                            *"
echo -e " **************************************************************"
echo -e "${Default} "

find . -type f \( -name "Regions.ini" \) ! -path "./Templates/*" -print0 | xargs -0 grep -v '{http_listener_port}' | grep -v 'RegistryLocation' | grep -T -e '\[' -T -e 'http_listener_port' -T -e 'InternalPort = ' -T -e 'RegionUUID =' -T -e 'Location =' 


#1234567890123456789012345678901234567890123456789012345678901234567890123456789
################################################################################

echo ""
echo -e "${Yellow}*** End of run ***${Default}"

exit 0

fi

































################################################################################




