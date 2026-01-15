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
fitness=$(podman ps | grep 'fitness_maria')
sardines=$(podman ps | grep 'sardine_mysql')
seamanship=$(podman ps | grep 'seamanship_db')

# If/else condition to check if either the Halloween, Tins(Sardine), Seamanship or Fitness container is online; if so, create a backup 
# of the applicable SQL container
if [[ "$hallow" ]]; then
  echo "Backing up Halloween database now..."
  sleep 1
  podman exec -it halloween_mysql mysqldump --set-gtid-purged=OFF halloween > "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-halloween.sql
  podman exec -it halloween_mysql mysqldump --hex-blob halloween > "$HOME"/db-backups/mysql/hex-dumps/"$(date +%F)"-halloween-hex.sql
  rm "$HOME"/containers/halloween/mysql/volumes/*
  cp "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-halloween.sql "$HOME"/containers/halloween/mysql/volumes/
  echo "Halloween database backup complete.  New SQL file has been placed in container volume.  Restarting Halloween MySQL container now..."
  sleep 1
  podman restart halloween_mysql
  echo "Halloween MySQL container has been restarted.  All done!"
elif [[ "$sardines" ]]; then
  echo "Backing up Tins database now..."
  sleep 1
  podman exec -it sardine_mysql mysqldump --set-gtid-purged=OFF tins > "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-tins.sql
  podman exec -it sardine_mysql mysqldump --hex-blob tins > "$HOME"/db-backups/mysql/hex-dumps/"$(date +%F)"-tins-hex.sql
  rm "$HOME"/containers/sardines/mysql/volumes/*
  cp "$HOME"/db-backups/mysql/standard-dumps/"$(date +%F)"-tins.sql "$HOME"/containers/sardines/mysql/volumes/
  echo "Tins database backup complete.  New SQL file has been placed in container volume.  Restarting SARDINE MySQL container now..."
  sleep 1
  podman restart sardine_mysql
  echo "Tins MySQL container has been restarted.  All done!"
elif [[ "$fitness" ]]; then
  echo "Backing up Fitness database now..."
  sleep 1
  podman exec -it fitness_maria mariadb-dump fitness > "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-fitness.sql
  rm "$HOME"/containers/fitness/mariadb/volume/*
  cp "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-fitness.sql "$HOME"/containers/fitness/mariadb/volume/
  echo "Fitness database backup complete.  New SQL file has been placed in container volume.  Restarting Fitness MariaDB container now..."
  sleep 1
  podman restart fitness_maria
  echo "Fitness MariaDB container has been restarted.  All done!"
elif [[ "$seamanship" ]]; then
  echo "Backing up Seamanship database now..."
  sleep 1
  podman exec -it seamanship_db mariadb-dump study > "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-seamanship.sql
  rm "$HOME"/containers/seamanship/mariadb/volume/*
  cp "$HOME"/db-backups/mariadb/standard-dumps/"$(date +%F)"-seamanship.sql "$HOME"/containers/seamanship/mariadb/volume/
  echo "Seamanship database backup complete.  New SQL file has been placed in container volume.  Restarting Seamanship MariaDB container now..."
  sleep 1
  podman restart seamanship_db 
  sleep 1
  echo "Seamanship MariaDB container has been restarted.  All done!"
else
  echo "Unable to create backup; database container is not online."
fi

# EOF
