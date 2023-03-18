#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# run DB dump file
psql -U postgres < number_guess.sql
echo -e "\nDB relations loaded:"
echo $($PSQL "\d")
