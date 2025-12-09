#!/usr/bin/env bash

# TITLE: check_connections.sh
# AUTHOR: Boardleash (Derek)
# DATE: Wednesday, March 19 2025

# Check connectivty to VM hosts; tested on CentOS Stream 9

# Replace the following:
#   > HOST A/B/C --> your hosts/IPs

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
hvar=("HOST A" "HOST B" "HOST C")

# For loop with nested if/else statement to ping the above array and notify if online or not
printf "%s\n" "$(date +%c)"": Starting check_connections script..." | tee -a "$logfile"
for host in "${hvar[@]}"; do
  if [[ $(ping -c 2 -O "$host") && $? == 0 ]]; then
    printf "%s\n" "$(date +%c)"": $host is ONLINE!" | tee -a "$logfile"
  else
    printf "%s\n" "$(date +%c)"": $host is OFFLINE!" | tee -a "$logfile"
  fi
done
printf "%s\n" "$(date +%c)"": Completed check_connections script" | tee -a "$logfile"
printf "\n"

# EOF
