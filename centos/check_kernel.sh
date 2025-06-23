#!/usr/bin/env bash

# TITLE: check_kernel.sh
# AUTHOR: Boardleash (Derek)
# DATE: Wednesday, March 19 2025

# Pull kernel information from VM hosts
# As of 25MAR2025, this script will only work with the '<SPECIAL USER>' user.
# This is local to me; feel free to make changes as necessary.

# Replace the following:
#   > HOST A/B/C --> your hosts/IPs
#   > SPECIAL USER --> whatever user you prefer to run the script and/or is capable of running on
#                      other hosts

# Tested on CentOS Stream 9 

# Debug
#set -x

# Set variable trap; exit script if variable is used that is undefined
set -u

###############
# VARIABLES
#############

# Log file variable
logfile=/PATH/TO/LOGFILE/

# Variable to store the array of hosts
hfile=("HOST A" "HOST B" "HOST C")

# Verify who the user is that is running this script and stop if it is incorrect user
printf "%s\n" "$(date +%c)"": Starting check_kernel script..." | tee -a "$logfile"
if [ "$USER" != '<SPECIAL USER>' ]; then
  printf "%s\n" "$(date +%c)"": INVALID USER: EXITING!" | tee -a "$logfile"
  exit 126
fi

# For loop with nested if/else statement to use the above array and ssh to the host
# and pull the kernel information
for host in "${hfile[@]}"; do
  if [[ $(ping -c 2 -O "$host") && $? == 0 ]]; then
    grabkern=$(ssh "$USER"@"$host" 'uname -r')
    printf "%s\n" "$(date +%c)"": $host KERNEL= $grabkern" | tee -a "$logfile"
  else
    printf "%s\n" "$(date +%c)"": $host is OFFLINE!" | tee -a "$logfile"
  fi
done
printf "%s\n" "$(date +%c)"": Completed check_kernel script" | tee -a "$logfile"
printf "\n"

# EOF
