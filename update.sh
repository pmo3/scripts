#!/bin/bash

# This script will go out to whaterver address you supply, download the file, and run a diff on the file to determine if it's a newer version or not.

# Variables
VER="1.4" # A variable to call the version so that the user knows they've updated properly
UPDATE_FILE="$0.tmp"
UPDATE_BASE="http://raw.githubusercontent.com/kyle95wm/scripts/master/update.sh"

# The UPDATE_FILE and UPDATE_BASE can be whatever you want


# Now it's time to impliment the update feature into our script.

# We can either straight out write it into the script, or put it into a function


# In this example I will put it into a function
function update_init {
echo "Checking for available update methods....."
which wget >/dev/null # Check if wget is installed
if [ $? != "0" ] ; then
	which curl >/dev/null # Check if curl is installed
else
	update
	if [ $? != "0" ] ; then
		echo "No available update methods found!"
		exit 1
	else
		update
	fi
fi
}
function update {
# The following lines will check for an update to this script if the -s switch
# is not used.

# Original code by Dennis Simpson
# Modified by Kyle Warwick-Mathieu
if [ "$1" != "-s" ]; then # If there is no -s argument then run the updater
	echo "Checking if script is up to date, please wait"
	wget -nv -O $UPDATE_FILE $UPDATE_BASE >& /dev/null # This will silently download the file
	if [ $? != "0" ] ; then
		curl "$UPDATE_BASE" -o "$UPDATE_FILE" >& /dev/null
	fi
	diff $0 $UPDATE_FILE >& /dev/null # This will compare the current file you're running against the newly downloaded file
	if [ "$?" != "0" -a -s $UPDATE_FILE ]; then # If the exit code is not 0 (in other words if the file is different)
		mv $UPDATE_FILE $0 # Rename update file to the script you're running
		chmod +x $0 # Change the mode on the newly renamed file
		echo "$0 updated"
		$0 -s # Runs the script with the -s argument to prevent an endless loop
		exit
	else
		rm $UPDATE_FILE # If no updates are available, simply remove the file
	fi
fi
}

# Now we have to call the update function

update_init
update # This will call our update function

echo "Hello! I'm version $VER of the script!"
