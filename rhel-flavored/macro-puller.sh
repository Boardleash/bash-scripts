#!/usr/bin/env bash

#------------------------------
# TITLE: macro-puller.sh
# AUTHOR: Boardleash (Derek) 
# DATE: Monday, April 6th 2026 
#------------------------------

#------------------------------- DESCRIPTION ----------------------------------
# Script to pull monthly and weekly macro metrics from a database for data 
# collection and manipulation.
#------------------------------------------------------------------------------

#set -x

month_file="$HOME"/monthly-macro-stats
week_file="$HOME"/weekly-macro-stats

# Check if appropriate db container is online
database=$(podman ps | grep mariadb_database)
if [[ "$database" ]]; then

  # Ask user for which data they want to pull and pull that data
  read -erp "Monthly or weekly data? ('M/m' or 'W/w'): " timeframe

  if [[ "${timeframe,,}" == "m" ]]; then
    read -erp "Please provide the month: " month 
    start_date=$(date -d "$month 1 2026" +%F)
    end_date=$(date -d "$start_date +1 month -1 day" +%F)
    date -d "$start_date" +%B\ \%Y >> "$month_file"
    podman exec -it mariadb_database mariadb -D fitness -e "select sum(cal) as \
    calories,sum(pro) as protein,sum(carb) as carbs,sum(fat) as fat from meals \
    where date between '$start_date' and '$end_date';" >> "$month_file"
    echo "" >> "$month_file"
  elif [[ "${timeframe,,}" == "w" ]]; then
    read -erp "Provide month and day for Monday of the week that you want: " week
    pref_week=$(date -d "$week" +%F)
    date -d "$pref_week" +%B\ \%d\ \%Y >> "$week_file"
    podman exec -it mariadb_database mariadb -D fitness -e "select sum(cal) as \
    calories,sum(pro) as protein,sum(carb) as carbs,sum(fat) as fat from meals \
    where week(date,1)=week('$pref_week',1);" >> "$week_file"
    echo "" >> "$week_file"
  else
    echo "Invalid input"
  fi
else
  echo "Database is not online.  Unable to continue."
fi

# EOF
