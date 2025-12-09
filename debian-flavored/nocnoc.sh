#!/bin/bash
#
# TITLE: nocnoc
# AUTHOR: Boardleash (Derek)
# DATE: Tuesday, August 13 2024
#
#.:::::----======++**-:...........:-**+++
#.::::-----====+*+:......::...::::::::-##*+
#:::::-----===*%:-::::--:::.:::----::-=-%@*+
#.:::::----=#@@##-:---:...........:--*%--%@*
#.:::::----*@@@%#%%=::...............:+%#-%%=
#..::::::--#@@@%%*..-:.................:#@@@+
#...::::::=@@@%#:....:................::-%@@#
#....:::::*@@@%+-:...:.................:=*@@%
#......:::*@@@%+--..:-+*#########*#*+-..=*%@@
#......:::+@@@#+::+%@@@@@@@@##@@@@@@@@%*-##@@
#.........*@@@@++#%#=-=####*:.*@%#=--*%%%*%@#
#.........:@@@@%##**%@@%%#+....+*#@@@@@%%@+@#
#..........*@@@#*==******+:....:*+++*****%=@*
#.........:*@@%=*+====+=-:=*++#*-==+*+=-=*=%*
#........:@@#%++#*+==++--%@@@@@@%*==-==+*%%#%@#
#........-*##%%###*#**=-=*=---=++=-=+++**%%@##=
#........:##+#%%#**#%*+-:=-----=+:.=++*++#%@#*-
#.........-#==%%%####**-:=====**=++-+++=+#%@++
#.........:+***%*##*#%%##%@%#**%@@%+:===+#%#+=
#..........-#**####+*%*#*=--=====:....-++#%++
#..............:*%#=+===+===---===--::-*#%
#...............*%%=====+=-----:..::.-*##
#...............+@@#*+::-==---:....:+#%@%
#...............=%@@@%%*+=+++++*#**%@@@@#
#.......::::::::+*#@@@@@@@%%@@@@@@@@@@@@@%+:
#......::::::*++*#**%@@@@@@@@@@@@@@@@@@@@@#*-
#.....::::::::.=%*****%@@@@@@@@@@@@@@@@@@@%+:
#.....::::::.-%@%##*****#@@@@@@@@@@@@@@@@@@@@#-
#......::.:*@@@@%%#****###%@@@@@@@@@@@@%%%@@@%**-
#..:-=*#%@@@@@@@@@%%%##%%%%%##%@@@@@@@@@@@@@@@###*+==-::
# A simple script that pulls user information on a machine.
# It is recommended to run this with escalated privileges (sudo).
# Tested on Ubuntu LTS 24.04 (server and GUI) VM images.

# Create some formatting variables.
brd='\033[3;31m'
noc='\033[0m'

# Set up an intro function.
intro() {
	echo -e "\n"$brd"Hey there!  Would you like to see who's been on your system?"$noc""
	read -p "                   Yes or No?: " response
}

# Set up the function for if the user DOES want to see who's been on their system.
thedoor() {
	echo -e "\n"$brd"WHO IS ACTUALY RUNNING THIS SCRIPT:"$noc" $(logname)"
	echo -e "\n"$brd"USERS ALREADY PRESENT ON HOST"$noc"\n"
 	# Check the passwd file for users that currently reside on the host.
	urusers=$(grep "/bin/bash\|/bin/sh\|/bin/csh\|/bin/ksh\|/bin/zsh\|/bin/ion\|/bin/dash\|/bin/ash" /etc/passwd | awk -F: '{print $1}')
	echo "$urusers"
	echo -e "\n"$brd"WHO IS LOGGED INTO YOUR MACHINE RIGHT NOW"$noc"\n"
 	# Run the 'w' command to capture who is currently logged in.
	currentlogins=$(w | sed '1d' | awk '{print $1}' | sed '1d' | sort -u)
	echo "$currentlogins"
	echo -e "\n"$brd"WHO HAS ACCESSED YOUR MACHINE"$noc"\n"
 	# Run the 'last' command to see who has successfully logged into your machine.
	accessed=$(last -w | awk '{print $1}' | sort -u | sed -e '/wtmp/d' -e '/reboot/d' -e '1d')
	echo "$accessed"
	echo -e "\n"$brd"WHO TRIED TO ACCESS YOUR MACHINE"$noc"\n"
 	# Run the 'lastb' command to capture who attempted to login to your machine, but unsuccessfully.
	lastb > /dev/null
	if [ $(echo $?) == 0 ]; then
 		# If you are running the command with escalated privileges, then present the information nicely.
		attemptsfull=$(lastb | awk '{print $1,$3,$4,$5,$6}' | sed '$d')
		echo "$attemptsfull"
	else
 		# If you are NOT running the command with escalated privileges, then let the user know that.
		echo "You need elevated privileges to see this information."
	fi
	echo -e "\n"$brd"          Knock, Knock!"$noc"\n"
} 2> /dev/null

# Set up main function to run the options.
main() {
	intro
	if [ "$response" == 'Yes' ] || [ "$response" == 'Y' ] || [ "$response" == 'yes' ] || [ "$response" == 'y' ]; then
		thedoor
	elif [ "$response" == 'No' ] || [ "$response" == 'N' ] || [ "$response" == 'no' ] || [ "$response" == 'n' ]; then
		echo -e "\n"$brd"Ah...out of sight, out of mind..."$noc"\n"
	else
		echo -e "\nYou did not enter a vaild response.  Please try again, otherwise, press 'Ctrl+C' to exit this script."
		main
	fi
}

# Run the script.
main

# EOF
