#!/usr/bin/env bash

# TITLE: startup_hosts.sh
# AUTHOR: Boardleash (Derek)
# DATE: Wednesday, April 2 2025

# Power on VM servers (if they are offline); tested on CentOS Stream 9

# Replace the following:
#   > HOST A/B/C --> your hosts/IPs

# Debug
#set -x

# Check for pipeline failures
set -o pipefail

# Check against undefined variables
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
printf "%s\n" "$(date +%c)"": Starting startup_hosts script..." | tee -a "$logfile"
if [ ! "$SUDO_USER" ]; then
  printf "%s\n" "$(date +%c)"": /// UNABLE TO RUN SCRIPT: PLEASE ELEVATE \\\\\\\\\\\\" | tee -a "$logfile"
  exit 126
fi

# Ask for user input and use that input moving forward
read -rp "Do you want to startup ALL hosts? (Y/n): " starthost

# If/else statement, based on prior user input.  Regardless of answer, ping the host(s)
# to verify if they are already online.  If so, do nothing, otherwise, power on the host
if [ "$starthost" == 'N' ] || [ "$starthost" == 'n' ]; then
  read -rp "Which host would you like to startup (HOST A, HOST B, HOST C)?: " specifichost
  if [[ $(ping -c 2 -O "$specifichost") && $? != 0 ]]; then
    printf "%s\n" "$(date +%c)"": $specifichost is OFFLINE: Attempting to power on now!" | tee -a "$logfile"
    virsh start "$specifichost"
  else
    printf "%s\n" "$(date +%c)"": $specifichost is ONLINE: Nothing to do!" | tee -a "$logfile"
  fi
elif [ "$starthost" == 'Y' ] || [ "$starthost" == 'y' ]; then
  for host in "${hfile[@]}"; do
    if [[ $(ping -c 2 -O "$host") && $? != 0 ]]; then
      printf "%s\n" "$(date +%c)"": $host is OFFLINE: Attempting to power on now!" | tee -a "$logfile"
      virsh start "$host"
    else
      printf "%s\n" "$(date +%c)"": $host ia ONLINE: Nothing to do!" | tee -a "$logfile"
    fi
  done
else
	echo "Invalid response; EXITING!"
	exit 1
fi
printf "%s\n" "$(date +%c)"": Completed startup_hosts script." | tee -a "$logfile"

# EOF
