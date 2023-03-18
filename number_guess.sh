#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME
# oos: check username length (additional requirement - out of scope (oos))
# query DB for Username
USER_INFO=$($PSQL "SELECT * FROM users WHERE username='$USERNAME';")
if [[ -z $USER_INFO ]] # if username doesn't exist
then
  CREATE_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  echo "$USER_INFO" | while IFS="|" read USER_ID USERNAME GAMES_PLAYED BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi
