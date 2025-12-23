#!/usr/bin/env bash

########################################
# TITLE: sql-backup-cleanup.sh
# AUTHOR: Boardleash
# DATE: Tuesday, October 14 2025
#####################################

# This is a cleanup script for database backup files as they start to take up space

# Check if there is a cleanup-stats file already created.  If not, create one, otherwise,
# append a space to it to start the new cleanup stats
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


# Check for the five most recent HALLOWEEN database backup files
# Keep those files and remove the older HALLOWEEN database backup files
halloween_bkp_count=$(find "$HOME"/db-backups/mysql/ -type f -name '*halloween*' | sort -r | sed '3,$d' | wc -l)

if [[ "$halloween_bkp_count" -lt 2 ]]; then
  printf "There are not enough Halloween SQL backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mysql/ -type f -name '*halloween*' -print | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent HALLOWEEN STANDARD database backup files have been preserved.  All others have been removed."
fi

# Check for the five most recent TINS database backup files
# Keep those files and remove the older TINS database backup files
sardine_bkp_count=$(find "$HOME"/db-backups/mysql/ -type f -name '*tins*' | sort -r | sed '3,$d' | wc -l)

if [[ "$sardine_bkp_count" -lt 2 ]]; then
  printf "There are not enough Tins SQL backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mysql/ -type f -name '*tins*' | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent TINS database STANDARD backup files have been preserved.  All others have been removed."
fi

# Check for the five most recent FITNESS database backup files
# Keep those files and remove the older FITNESS database backup files
fitness_bkp_count=$(find "$HOME"/db-backups/mariadb/ -type f -name '*fitness*' | sort -r | sed '3,$d' | wc -l)

if [[ "$fitness_bkp_count" -lt 2 ]]; then
  printf "There are not enough FITNESS SQL backup files to go over.\n"
else
  remove_bkps=$(find "$HOME"/db-backups/mariadb/ -type f -name '*fitness*' | sort -r | sed '1,2d')
  for bkp in $remove_bkps; do
    rm "$bkp"
  done
  echo "2 most recent FITNESS database STANDARD backup files have been preserved.  All others have been removed."
fi

# Check the new amount of space used after file cleanup
new_space=$(du -s "$HOME"/db-backups/mysql/ | awk '{print $1}')

# Get a number of how much space was saved after doing the cleanup
saved_space=$(($original_space - $new_space))
echo "$(date +%c) SPACE PRIOR TO FILE CLEANUP: $original_space bytes" >> "$check_file"
echo "$(date +%c) SPACE AFTER FILE CLEANUP: $new_space bytes">> "$check_file"
echo "$(date +%c) SPACE SAVED: $saved_space bytes ">> "$check_file"

# EOF
