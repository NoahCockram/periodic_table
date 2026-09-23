#!/bin/bash
# This script is designed to return a description of an element when given an atomic number, atomic symbol or element name as an argument.

# Replace this with whatever the name for your server and username are, and to enter passwords without prompt if need be.
PSQL="psql --username=USERNAME --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]] # If the first argument doesn't exist, then the user hasn't provided an element that they want to search for. Therefore program terminates.
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+ ]] # If an atomic number is provided...
  then
    QUERY=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")
  elif [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]] # If an atomic symbol is provided...
  then
    QUERY=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1';")
  elif [[ $1 =~ ^[a-zA-Z]{3,}$ ]] # If an element name is provided...
  then
    QUERY=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1';")
  else # If an invalid format is used for the argument, the program terminates.
    echo "I could not find that element in the database."
  fi
  
  if [[ -z $QUERY ]] # If the argument is of a correct format but does not exist in the periodic table, e.g. atomic number 256, element name Foobarrium, then the program terminates.
  then
    echo "I could not find that element in the database."
  else # If the argument is of the correct format, and a corresponding element is found in the database, then we return a statement describing its properties.
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE <<< $QUERY
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi