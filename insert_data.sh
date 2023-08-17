#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Script to insert data from games.csv into games and teams table
echo $($PSQL "TRUNCATE teams, games")

# insert team (unique) name( winner and opponent)
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $YEAR != "year" ]]
then 
#get team_id
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
 
#if not found 
if [[ -z $WINNER_ID ]]
then
  echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi

#get team_id for opponent
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#IF NOT FOUND
if [[ -z $OPP_ID ]]
then
  echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi

echo $($PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES($WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, $YEAR,'$ROUND')")
fi
done
