#!/bin/bash

function clear_screen
{
# clear screen
echo -e '\0033\0143'
} # end of clear screen function

function define_ansi_codes
{
#define ANSI escape codes for colourisation
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[1;33m'
Default='\033[0m'
} # end of define_ansi_codes function

function display_header
{
# display header

echo -e "${Yellow} **************************************************************"
echo -e " *                                                            *"
echo -e " *    create simulator.sh - version 00.2 - 11th June 2016    *"
echo -e " *                                                            *"
echo -e " **************************************************************"
echo -e "${Default} "
echo -e "You will need to input:"
echo -e "                       Directory Name (Use underscores ${Red}not spaces${Default}!\e[39m)"
echo -e "                       Simulator Name (You ${Green}can${Default} use spaces here!)"
echo -e "                       Max Prims (15k is default - choose Y to accept or N to change)"
echo -e "                       Simulator Size (256, 512 or 768 square metres)"
echo -e "                       Simulator Port"
echo -e "                       Simulator X Co-ordinate"
echo -e "                       Simulator Y Co-ordinate"
echo

} # end of display_header function


function get_variables
{

# get variables

read -p "Directory Name: " directory_name

# strip out spaces from directory name

a=$(sed 's/ /_/g' <<< "$directory_name")

directory_name=$a

echo -en "\033[1A\033[2K"

read -p "Simulator Name: " simulator_name

# strip out spaces from sim name & assign to monit_sim_name

b=$(sed 's/ /_/g' <<< "$simulator_name")

config_sim_name=$b

echo -en "\033[1A\033[2K"

read -p "Simulator Port: " simulator_port

echo -en "\033[1A\033[2K"

read -p "Size: (Enter either 256, 512 or 768 for 1x1, 2x2 or 3x3)  " size

echo -en "\033[1A\033[2K"

read -p "Simulator X Co-ordinate: " x_coordinate

echo -en "\033[1A\033[2K"

read -p "Simulator Y Co-ordinate: " y_coordinate

echo -en "\033[1A\033[2K"

read -p "Accept 15K Max Prims <y/N> " -e -i "y" prompt

echo -en "\033[1A\033[2K"

if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]

then

maxprims="15000"

elif

[[ $prompt == "n" || $prompt == "N" || $prompt == "no" || $prompt == "No" || $prompt == "yn" || $prompt == "yN" || $prompt == "yno" || $prompt == "yNo" ]]

then

echo -e "${Default}"

read -p "Please enter a number between 16 and 45 for thousands of prims " newmaxprims

maxprims=$((newmaxprims * 1000))

echo "$maxprims"

fi

# generate UUID and allocate to a variable

uuid=$(uuidgen)

echo -en "\033[1A\033[2K"

echo -e "Config Sim Name: ${Yellow}"$config_sim_name
echo -e "Directory Name: ${Yellow}"$directory_name
echo -e "${Default}Simulator Name: ${Yellow}"$simulator_name
echo -e "${Default}Region UUID: ${Yellow}"$uuid
echo -e "${Default}Simulator Port: ${Yellow}"$simulator_port
echo -e "${Default}X Co-ordinate: ${Yellow}"$x_coordinate
echo -e "${Default}Y Co-ordinate: ${Yellow}"$y_coordinate
echo -e "${Default}Xsize: ${Yellow}"$size
echo -e "${Default}Ysize: ${Yellow}"$size
echo -e "${Default}MaxPrims: ${Yellow}"$maxprims

} # end of get_variables function

function confirm_to_input_variables
{
# confirm to proceed

echo -e "${Default}"

read -p "Would you like to continue? <y/N> " -e -i "y" prompt

if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]

then

get_variables

else
echo "Exiting program"
fi
} # end of confirm_to_input_variables function

function confirm_to_repeat
{
# confirm to repeat

echo -e "${Default}"

read -p "Would you like to add another sim? <y/N> " -e -i "N" prompt

if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]

then

commence

else
echo "Exiting program"
fi
} # end of confirm_to_repeat function


function create_sim
{
echo ""

echo "Creating Directory"

# create directory to hold sim file
mkdir /home/opensim/opensim/bin/grid/$directory_name

echo -e "${Green}Done!${Default}"

echo -e "Copying Files"

# copy files from template directory into newly created sim directory
cp -r /home/opensim/opensim/bin/grid/Templates/* /home/opensim/opensim/bin/grid/$directory_name/

echo -e "${Green}Done!${Default}"

echo -e "Replacing values in template files..."

#change into newly created directory

cd $directory_name

#make directory and files writeable recursively
chmod -R +w *

find . -type f -print0 | xargs -0 sed -i "s/@@Directory Name@@/$directory_name/g"
find . -type f -print0 | xargs -0 sed -i "s/@@Port@@/$simulator_port/g"
find . -type f -print0 | xargs -0 sed -i "s/@@Simulator Name@@/$simulator_name/g"
find . -type f -print0 | xargs -0 sed -i "s/@@X Location@@/$x_coordinate/g"
find . -type f -print0 | xargs -0 sed -i "s/@@Y Location@@/$y_coordinate/g"
find . -type f -print0 | xargs -0 sed -i "s/@@UUID@@/$uuid/g"
find . -type f -print0 | xargs -0 sed -i "s/@@Monit Name@@/$config_sim_name/g"
find . -type f -print0 | xargs -0 sed -i "s/@@SizeX@@/$size/g"
find . -type f -print0 | xargs -0 sed -i "s/@@SizeY@@/$size/g"
find . -type f -print0 | xargs -0 sed -i "s/@@MaxPrims@@/$maxprims/g"

echo -e "${Green}Done!${Default}"

echo -e "Renaming template files..."

rename -v 's/^TEMPLATE_//' *

cd Regions

rename -v 's/^TEMPLATE_//' *

cd ..

echo -e "${Green}Done!${Default}"

rename -v "s/^monit/$config_sim_name/" *

echo -e "Moving monit config scripts..."
echo -e "... & reloading monit"

# run script to move monit conf file

sudo /bin/bash move_to_monit.sh

echo -e "${Green}Done!${Default}"

# Change into target directory

cd /home/opensim/opensim/bin/grid/$directory_name

# make files un-writeable

#chmod -R -w `find -type f`

chmod -R 0400 `find -type f`
chmod 0500 Regions
chmod 0500 start* stop*
chmod 0500 move_to_monit.sh
chmod 0500 *.conf

cd /home/opensim/opensim/bin/grid/

} # end of create_sim function


function clear_sim_variables
{

unset directory_name
unset simulator_name
unset config_sim_name
unset size
unset simulator_port
unset x_coordinate
unset y_coordinate
unset uuid
unset maxprims
unset newmaxprims
unset size
unset a
unset b

} # end of clear_sim_variables


# actual program starts here

function commence
{
clear_sim_variables
clear_screen
define_ansi_codes
display_header
confirm_to_input_variables
create_sim
confirm_to_repeat
}

commence
