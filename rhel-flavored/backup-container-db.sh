#!/usr/bin/env bash

#----------------------------------
# TITLE: backup-container-db.sh
# AUTHOR: Boardleash (Derek)
# DATE: Monday, October 13th 2025
#----------------------------------

#--------- DESCRIPTION -----------------
# Script to back up container databases. 
#---------------------------------------

#set -x

# Grep for container names to store in variable (if they are active)
demersal=$(podman ps | grep -e 'mariadb_database' -e 'mysql_database')
seamanship=$(podman ps | grep 'seamanship_db')

# Conditional statement to check against variables above and run appropriate commands
if [[ "$seamanship" ]]; then
  echo "Backing up SEAMANSHIP database now..."; sleep 1
  podman exec -it seamanship_db mariadb-dump study > "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-seamanship.sql
  rm "$HOME"/containers/seamanship/mariadb/volume/*
  cp "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-seamanship.sql "$HOME"/containers/seamanship/mariadb/volume/
  echo "SEAMANSHIP database backup complete.  New SEAMANSHIP SQL file has been placed in container volume."
  echo "Restarting SEAMANSHIP MariaDB container now..."; sleep 1
  podman restart seamanship_db; sleep 1
  echo "SEAMANSHIP MariaDB container has been restarted.  All done!"
elif [[ "$demersal" ]]; then
  echo "Backing up MariaDB and MySQL databases now..."; sleep 1
  podman exec -it mariadb_database mariadb-dump --databases fitness trails > "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-everything.sql
  rm "$HOME"/containers/demersal/mariadb/volume/*
  cp "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-everything.sql "$HOME"/containers/demersal/mariadb/volume/
  sleep 1
  podman exec -it mysql_database mysqldump --set-gtid-purged=OFF tins > "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-tins.sql
  rm "$HOME"/containers/demersal/mysql/volume/*
  cp "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-tins.sql "$HOME"/containers/demersal/mysql/volume/
  sleep 1
  echo "MariaDB and MySQL database backup complete.  New database SQL files have been placed in container volumes."
  echo "Restarting all database containers now..."; sleep 1
  podman restart mariadb_database; sleep 1
  podman restart mysql_database; sleep 1
  echo "Database containers have been restarted.  All done!"
else
  echo "Unable to create backup; SQL container is not online."
fi

# EOF
