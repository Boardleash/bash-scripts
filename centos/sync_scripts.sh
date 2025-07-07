#!/usr/bin/env bash

# TITLE: sync_scripts.sh
# AUTHOR: Boardleash (Derek)
# DATE: Friday, March 28 2025

# Check if hosts are online, and, if so, rsync the /usr/local/bin/ scripts to the hosts
# As of 28MAR2025, this script will only work with the <SPECIAL USER>.
# This configuration is local to me; make changes as necessary for your system

# Replace the following:
#		> HOST A/B/C --> your hosts/IPs
#		> SPECIAL USER --> whatever user you prefer to run the script and/or is capable of running on
#											 other hosts

# Tested on CentOS Stream 9

# Debug
# set -x

# Check for pipeline failure
#set -o pipefail

# Check for undefined variables
# set -u

##############
# VARIABLES
############

# Log file variable
logfile=/PATH/TO/LOGFILE

# Variable to store array of hosts
hfile=("HOST A" "HOST B" "HOST C")

################
# THE SCRIPT
#############

# Verify who the user is that is running this script and stop if it is incorrect user
printf "%s\n" "$(date +%c)"": Starting sync_scripts script..." | tee -a "$logfile"
if [ "$USER" != '<SPECIAL USER>' ]; then
  printf "%s\n" "$(date +%c)"": INVALID USER: EXITING!" | tee -a "$logfile"
  exit 126
fi

# Ask for user input and use that input moving forward
read -rp "Do you want to sync your local scripts to ALL hosts? (Y/n): " answer

# If/else statement, based on prior user input.  Sync scripts to host(s) based on the input
if [ "$answer" == 'N' ] || [ "$answer" == 'n' ]; then
	read -rp "Which host would you like to sync local scripts to (HOST A, HOST B, HOST C)?: " target
  if [[ $(ping -c 2 -O "$target") && $? == 0 ]]; then
    printf "%s\n" "$(date +%c)"": syncing local scripts to $target now!" | tee -a "$logfile"
    rsync -avih --delete --progress /usr/local/bin/ "$USER"@"$target":/usr/local/bin/
  else
    printf "%s\n" "$(date +%c)"": $target is not online!" | tee -a "$logfile"
  fi
elif [ "$answer" == 'Y' ] || [ "$answer" == 'y' ]; then
  for host in "${hfile[@]}"; do
    if [[ $(ping -c 2 -O "$host") && $? == 0 ]]; then
      printf "%s\n" "$(date +%c)"": syncing local scripts to $host now!" | tee -a "$logfile"
      rsync -avih --delete --progress /usr/local/bin/ "$USER"@"$host":/usr/local/bin/
    else
      printf "%s\n" "$(date +%c)"": $host is not online!" | tee -a "$logfile"
    fi
  done
else
	echo "Invalid response; exiting!"
	exit 1
fi
printf "%s\n" "$(date +%c)"": Completed sync_scripts script." | tee -a "$logfile"

# EOF
