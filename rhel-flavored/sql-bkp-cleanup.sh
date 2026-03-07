#!/usr/bin/env bash

#-----------------------------------
# TITLE: sql-backup-cleanup.sh
# AUTHOR: Boardleash
# DATE: Tuesday, October 14 2025
#-----------------------------------

#------------------ DESCRIPTION ------------------
# Cleanup script for database backup files as they 
# start to take up space.
#-------------------------------------------------

# Check for stats file; create one if needed or append to one that already exists
check_file="$HOME/sql-cleanup-stats"
if [ ! -e "$check_file" ]; then
  touch "$HOME"/sql-cleanup-stats
else
  echo " " >> "$check_file"
fi

# Check the original space, prior to backup file cleanup
original_space=$(du -s "$HOME"/db-backups/ | awk '{print $1}')

# Check for empty backup files and get rid of them
deleted_files=$(find "$HOME"/db-backups/ -type f -empty | wc -l)
echo "$(date +%c) EMPTY FILES DELETED: $deleted_files" >> "$check_file"
find "$HOME"/db-backups/ -type f -empty -delete

# Check for five most recent HALLOWEEN database backup files, keep them and remove older ones
halloween_bkp_count=$(find "$HOME"/db-backups/mysql/standard-dumps/ -type f -name '*halloween*' | sort -r | sed '3,$d' | wc -l)

if [[ "$halloween_bkp_count" -lt 2 ]]; then
  printf "There are not enough Halloween SQL backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mysql/standard-dumps/ -type f -name '*halloween*' -print | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent HALLOWEEN database backup files have been saved.  All others have been removed."
fi

# Check for five most recent TINS database backup files, keep them and remove older ones
sardine_bkp_count=$(find "$HOME"/db-backups/mysql/standard-dumps/ -type f -name '*tins*' | sort -r | sed '3,$d' | wc -l)
sardine_hex_count=$(find "$HOME"/db-backups/mysql/hex-dumps/ -type f -name '*tins*' | sort -r | sed '3,$d' | wc -l)

if [[ "$sardine_bkp_count" -lt 2 ]]; then
  printf "There are not enough TINS SQL STANDARD backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mysql/standard-dumps/ -type f -name '*tins*' | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent Tins database STANDARD backup files have been saved.  All others have been removed."
fi

if [[ "$sardine_hex_count" -lt 2 ]]; then
  printf "There are not enough TINS SQL HEX backup files to go over.\n"
else
  remove_hex=$(find "$HOME"/db-backups/mysql/hex-dumps/ -type f -name '*tins*' | sort -r | sed '1,2d')
  for hex in $remove_hex; do
    rm "$hex"
  done
  echo "2 most recent TINS database HEX backup files have been saved.  All others have been removed."
fi

# Check for five most recent FITNESS database backup files, keep them and remove older ones
fitness_bkp_count=$(find "$HOME"/db-backups/mariadb/standard-dumps/ -type f -name '*fitness*' | sort -r | sed '3,$d' | wc -l)

if [[ "$fitness_bkp_count" -lt 2 ]]; then
  printf "There are not enough FITNESS SQL backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mariadb/standard-dumps/ -type f -name '*fitness*' | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent FITNESS database backup files have been saved.  All others have been removed."
fi

# Check for five most recent TRAILS database backup files, keep them and remove the older ones
trails_bkp_count=$(find "$HOME"/db-backups/mariadb/standard-dumps/ -type f -name '*trails*' | sort -r | sed '3,$d' | wc -l)
if [[ "$trails_bkp_count" -lt 2 ]]; then
  printf "There are not enough TRAILS backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mariadb/standard-dumps/ -type f -name '*trails*' | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent TRAILS database backup files have been saved.  All others have been removed."
fi

# Check for five most recent EVERYTHING database backup files, keep them and remove the older ones
everything_bkp_count=$(find "$HOME"/db-backups/mariadb/standard-dumps/ -type f -name '*everything*' | sort -r | sed '3,$d' | wc -l)
if [[ "$everything_bkp_count" -lt 2 ]]; then
  printf "There are not enough EVERYTHING backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mariadb/standard-dumps/ -type f -name '*everything*' | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent EVERYTHING database backup files have been saved.  All others have been removed."
fi
# Check new amount of space used after file cleanup
new_space=$(du -s "$HOME"/db-backups/mysql/ | awk '{print $1}')

# Get number of how much space was saved after cleanup
saved_space=$(($original_space - $new_space))
echo "$(date +%c) SPACE PRIOR TO FILE CLEANUP: $original_space bytes" >> "$check_file"
echo "$(date +%c) SPACE AFTER FILE CLEANUP: $new_space bytes">> "$check_file"
echo "$(date +%c) SPACE SAVED: $saved_space bytes ">> "$check_file"

# EOF
