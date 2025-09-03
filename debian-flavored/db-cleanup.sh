#!/usr/bin/env bash

##########################
### TITLE: db-cleanup.sh
### AUTHOR: Boardleash (Derek)
### DATE: Wednesday, September 3 2025
######################################

#set -x
#set -u

basedir="$HOME"/db-backups/

# Create file to hold information regarding the cleanup
touch "$basedir""$(date +%Y-%m-%d)"-db-cleanup
cleanupstats="$basedir""$(date +%Y-%m-%d)"-db-cleanup

# Check for number of backups available for each type (individual db or full)
tinsdb=$(find "$basedir" -type f -name '*tins*' | wc -l)
trailsdb=$(find "$basedir" -type f -name '*trails*' | wc -l)
fulldb=$(find "$basedir" -type f -name '*full*' | wc -l)

# If more than four available, keep most recent four and remove rest
if [ "$tinsdb" -gt 4 ]; then
  time find "$basedir" -type f -mtime +28 -name '*tins*' >> "$cleanupstats" && 
  find "$basedir" -type f -mtime +28 -name '*tins*' -execdir rm -f {} \; && printf '' >> "$cleanupstats"
else
  printf "No files to remove\n" >> "$cleanupstats"
fi

if [ "$trailsdb" -gt 4 ]; then
  time find "$basedir" -type f -mtime +28 -name '*trails*' >> "$cleanupstats" && 
  find "$basedir" -type f -mtime +28 -name '*trails*' -execdir rm -f {} \; && printf '' >> "$cleanupstats"
else
  printf "No files to remove\n" >> "$cleanupstats"
fi

if [ "$fulldb" -gt 4 ]; then
  time find "$basedir" -type f -mtime +28 -name '*full*' >> "$cleanupstats" && 
  find "$basedir" -type f -mtime +28 -name '*full*' -execdir rm -f {} \; && printf '' >> "$cleanupstats"
else
  printf "No files to remove\n" >> "$cleanupstats"
fi

# EOF
