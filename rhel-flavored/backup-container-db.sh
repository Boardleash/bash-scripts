#!/usr/bin/env bash

#########################################
# TITLE: capture-container-db.sh
# AUTHOR: Boardleash (Derek)
# DATE: Monday, October 13th 2025
####################################

# This is a script to backup database changes.  Rather than going through the commands everytime I make a change to the databases, I'll
# just use a script.  In this case, I have containers running MySQL and MariaDB, so appropriate commands are used.

#set -x

# Check for the containers, via container name, that I use (change based on your requirements)
hallow=$(podman ps | grep 'halloween_mysql')
sardines=$(podman ps | grep 'sardine_mysql')
fitness=$(podman ps | grep 'fitness_maria')

# If/else condition to check if either the Halloween, Sardine, or Fitness container is online; if so, create a backup of the applicable SQL 
# container
if [[ "$hallow" ]]; then
  echo "Backing up HALLOWEEN database now..."
  sleep 1
  podman exec -it halloween_mysql mysqldump halloween > "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-halloween.sql
  podman exec -it halloween_mysql mysqldump --hex-blob halloween > "$HOME"/db-backups/mysql/hex-dumps/"$(date +%F)"-halloween-hex.sql
  rm "$HOME"/containers/halloween/mysql/volumes/*
  cp "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-halloween.sql "$HOME"/containers/halloween/mysql/volumes/
  echo "HALLOWEEN database backup complete."
  echo "New HALLOWEEN SQL file has been placed in container volume."
  echo "Restarting HALLOWEEN MySQL container now..."
  sleep 1
  podman restart halloween_mysql
  echo "HALLOWEEN MySQL container has been restarted."
  echo "All done!"
elif [[ "$sardines" ]]; then
  echo "Backing up TINS database now..."
  sleep 1
  podman exec -it sardine_mysql mysqldump tins > "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-tins.sql
  podman exec -it sardine_mysql mysqldump --hex-blob tins > "$HOME"/db-backups/mysql/hex-dumps/"$(date +%F)"-tins-hex.sql
  rm "$HOME"/containers/sardines/mysql/volumes/*
  cp "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-tins.sql "$HOME"/containers/sardines/mysql/volumes/
  echo "TINS database backup complete."
  echo "New TINS SQL file has been placed in container volume."
  echo "Restarting SARDINE MySQL container now..."
  sleep 1
  podman restart sardine_mysql
  echo "SARDINE MySQL container has been restarted."
  echo "All done!"
elif [[ "$fitness" ]]; then
  echo "Backing up FITNESS database now..."
  sleep 1
  podman exec -it fitness_maria mariadb-dump fitness > "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-fitness.sql
  rm "$HOME"/containers/fitness/mariadb/volume/*
  cp "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-fitness.sql "$HOME"/containers/fitness/mariadb/volume/
  echo "FITNESS database backup complete."
  echo "New FITNESS SQL file has been placed in container volume."
  echo "Restarting FITNESS MariaDB container now.."
  sleep 1
  podman restart fitness_maria
  echo "FITNESS MariaDB container has been restarted."
  echo "All done!"
elif [[ "$study" ]]; then
  echo "Backing up STUDY database now..."
  sleep 1
  podman exec -it study_maria mariadb-dump study > "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-study.sql
  rm "$HOME"/containers/testbank/mariadb/volume/*
  cp "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-study.sql "$HOME"/containers/testbank/mariadb/volume/
  echo "STUDY database backup complete."
  echo "New STUDY SQL file has been placed in container volume."
  echo "Restarting STUDY MariaDB container now.."
  sleep 1
  podman restart study_maria
  sleep 1
  echo "STUDY MariaDB container has been restarted."
  echo "All done!"
else
  echo "Unable to create backup; SQL container is not online."
fi

# EOF
