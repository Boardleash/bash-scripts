#!/usr/bin/env bash

#-----------------------------
# TITLE: backup-database.sh
# AUTHOR: Boardleash (Derek)
# DATE: Thursday, March 5 2026
#-----------------------------

#--------------------------- DESCRIPTION ----------------------------------
# A bash script to backup all databases being tracked on my local DB server
#--------------------------------------------------------------------------

# Set up user and password variables using a test user with limited privileges
DB_USER="testuser"
DB_PASS="test"

# Main script
echo "Creating databases backups...";sleep 2 
mariadb-dump -u "$DB_USER" --password="$DB_PASS" --single-transaction employment > "$HOME"/db-backups/"$(date +%F)"-employment.sql
if [[ "$(echo $?)" == 0 ]]; then
  echo "Employment database dump complete.";sleep 2 
else
  echo "Employment database dump failed.  Troubleshoot as necessary.";sleep 2
fi
mariadb-dump -u "$DB_USER" --password="$DB_PASS" --single-transaction finances > "$HOME"/db-backups/"$(date +%F)"-finances.sql
if [[ "$(echo $?)" == 0 ]]; then
  echo "Finances database dump complete.";sleep 2
else
  echo "Finances database dump failed.  Troubleshoot as necessary.";sleep 2
fi
mariadb-dump -u "$DB_USER" --password="$DB_PASS" --single-transaction fitness > "$HOME"/db-backups/"$(date +%F)"-fitness.sql
if [[ "$(echo $?)" == 0 ]]; then
  echo "Fitness database dump complete.";sleep 2
else
  echo "Fitness database dump failed.  Troubleshoot as necessary.";sleep 2
fi
mariadb-dump -u "$DB_USER" --password="$DB_PASS" --single-transaction trails > "$HOME"/db-backups/"$(date +%F)"-trails.sql
if [[ "$(echo $?)" == 0 ]]; then
  echo "Trails database dump complete."
else
  echo "Trails database dump failed.  Troubleshoot as necessary."
fi

# EOF
