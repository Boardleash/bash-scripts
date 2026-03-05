#!/usr/bin/env bash

#####################################
# TITLE: bash-weightlifting-stats.sh
# AUTHOR: Boardleash (Derek)
# DATE: Thursday, December 4th 2025
#####################################

# Bash script to pull weightlifting stats from weightlifting database

read -p "What data would you like to see (AVERAGE or TOTAL)?: " user_request
input=$(echo $user_request | tr '[:upper:]' '[:lower:]')

# AVERAGE stats
if [ $input == "average" ]; then
	query=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness --skip-column-names -e "select avg(weight_lbs) from weightlifting")
	echo "The average amount of weight lifted for ALL LIFTS is $query pounds."

	query_two=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select avg(weight_lbs) from weightlifting where muscle_group='legs'")
	echo "The average amount of weight lifted for LEGS is $query_two pounds."

	query_three=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select avg(weight_lbs) from weightlifting where muscle_group='back'")
	echo "The average amount of weight lifted for BACK is $query_three pounds."

	query_four=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select avg(weight_lbs) from weightlifting where muscle_group='chest'")
	echo "The average amount of weight lifted for CHEST is $query_four pounds."

	query_five=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select avg(weight_lbs) from weightlifting where muscle_group='shoulders'")
	echo "The average amount of weight lifted for SHOULDERS is $query_five pounds."

	query_six=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select avg(weight_lbs) from weightlifting where muscle_group='arms'")
	echo "The average amount of weight lifted for ARMS is $query_six pounds."
# TOTAL stats
elif [ $input == "total" ]; then
	query=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness --skip-column-names -e "select sum(weight_lbs) from weightlifting")
	echo "The sum of weight lifted for ALL LIFTS is $query pounds."
	
	query_two=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select sum(weight_lbs) from weightlifting where muscle_group='legs'")
	echo "The sum of weight lifted for LEGS is $query_two pounds."
	
	query_three=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select sum(weight_lbs) from weightlifting where muscle_group='back'")
	echo "The sum of weight lifted for BACK is $query_three pounds."
	
	query_four=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select sum(weight_lbs) from weightlifting where muscle_group='chest'")
	echo "The sum of weight lifted for CHEST is $query_four pounds."
	
	query_five=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select sum(weight_lbs) from weightlifting where muscle_group='shoulders'")
	echo "The sum of weight lifted for SHOULDERS is $query_five pounds."
	
	query_six=$(mariadb -u "$DB_USER" --password="$DB_PASS" -D fitness -N -e "select sum(weight_lbs) from weightlifting where muscle_group='arms'")
	echo "The sum of weight lifted for ARMS is $query_six pounds."
else
	echo "That is not a valid response."
fi

# EOF
