#!/bin/bash
# This script is designed to return a description of an element when given an atomic number, atomic symbol or element name as an argument.
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]] 
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+ ]]
  then
    QUERY=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")
  elif [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
  then
    QUERY=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1';")
  elif [[ $1 =~ ^[a-zA-Z]{3,}$ ]]
  then
    QUERY=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1';")
  else
    echo "I could not find that element in the database."
  fi
  
  if [[ -z $QUERY ]]
  then
    echo "I could not find that element in the database."
  else
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE <<< $QUERY
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi