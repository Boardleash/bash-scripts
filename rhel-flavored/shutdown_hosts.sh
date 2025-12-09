#!/usr/bin/env bash

# TITLE: shutdown_hosts.sh
# AUTHOR: Boardleash (Derek)
# DATE: Tuesday, March 25 2025

# Check if hosts are online, and, if so, shut them down
# As of 25MAR2025, this script will only work with the '<SPECIAL USER>' user
# This is local to me; make changes for your user configs as necessary

# Replace the following:
#   > HOST A/B/C --> your hosts/IPs
#   > SPECIAL USER --> whatever user you prefer to run the script and/or is capable of running on
#                      other hosts

# Tested on CentOS Stream 9

# Debug
#set -x

# Set pipefail check
set -o pipefail

# Set variable trap; exit script if there is an undefined variable
#set -u

###############
# VARIABLES
#############

# Log file variable
logfile=/PATH/TO/LOGFILE/

# Variable to store the array of hosts
hfile=("HOST A" "HOST B" "HOST C")

###############
# THE SCRIPT
#############

# Verify if the user running this script has ran it with elevated permissions
printf "%s\n" "$(date +%c)"": Starting shutdown_hosts script..." | tee -a "$logfile"
if [ ! "$SUDO_USER" ]; then
  printf "%s\n" "$(date +%c)"": /// UNABLE TO RUN SCRIPT: PLEASE ELEVATE \\\\\\\\\\\\" | tee -a "$logfile"
  exit 126 
fi

# Ask for user input and use that input moving forward
read -rp "Do you want to shutdown ALL hosts? (Y/n): " shuthost

# If/else statement, based on prior user input.  Regardless of answer, ping the host(s)
# to verify if they are online.  If they are, shut'em down.  Otherwise, do nothing
if [ "$shuthost" == 'N' ] || [ "$shuthost" == 'n' ]; then
  read -rp "Which host would you like to shutdown (HOST A, HOST B, HOST C)?: " specifichost
  if [[ $(ping -c 2 -O "$specifichost") && $? == 0 ]]; then
    printf "%s\n" "$(date +%c)"": $specifichost is being shutdown now!" | tee -a "$logfile"
    virsh shutdown "$specifichost"
    printf "%s\n" "$(date +%c)"": Completed shutdown_hosts script." | tee -a "$logfile"
  else
    printf "%s\n" "$(date +%c)"": is not online!" | tee -a "$logfile"
  fi
elif [ "$shuthost" == 'Y' ] || [ "$shuthost" == 'y' ]; then
  for host in "${hfile[@]}"; do
    if [[ $(ping -c 2 -O "$host") && $? == 0 ]]; then
      printf "%s\n" "$(date +%c)"": $host is ONLINE; SHUTTING DOWN NOW!" | tee -a "$logfile"
      virsh shutdown "$host"
    else
      printf "%s\n" "$(date +%c)"": $host is already OFFLINE.  Nothing to do." | tee -a "$logfile"
    fi
  done
    printf "%s\n" "$(date +%c)"": Completed shutdown_hosts script." | tee -a "$logfile"
else
  echo "Invalid response; exiting!"
  exit 1
fi

# EOF
