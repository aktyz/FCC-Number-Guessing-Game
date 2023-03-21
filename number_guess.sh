#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

GAME() {
echo -e "\nSecret: $SECRET"
until [[ $GUESS == $SECRET ]]
do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    else if [[ $GUESS > $SECRET ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      (( BEST_GAME++ ))
      else if [[ $GUESS < $SECRET ]]
      then
        echo -e "\nIt's higher than that, guess again:"
        (( BEST_GAME++ ))
      fi
    fi
  fi
done
echo -e "You guessed it in $BEST_GAME tries. The secret number was $SECRET. Nice job!"
}

echo -e "\nEnter your username:"
read USERNAME
# oos: check username length (additional requirement - out of scope (oos))
USER_INFO=$($PSQL "SELECT * FROM users WHERE username='$USERNAME';")
if [[ -z $USER_INFO ]]
then
  CREATE_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  echo "$USER_INFO" | while IFS="|" read USER_ID USERNAME GAMES_PLAYED BEST_GAME_DB
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME_DB guesses."
  done
fi

BEST_GAME_DB=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME';")
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME';")
BEST_GAME=1
SECRET=$(( RANDOM%1000+1 ))
echo -e "\nGuess the secret number between 1 and 1000:"
GAME

RESULTS=$($PSQL "UPDATE users SET games_played=($GAMES_PLAYED+1) WHERE username='$USERNAME';")
if [[ ! $BEST_GAME_DB || $BEST_GAME < $BEST_GAME_DB ]]
then
  RESULTS=$($PSQL "UPDATE users SET best_game=$BEST_GAME WHERE username='$USERNAME' ;")
fi
