#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
else
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")
  if [[ -z $ELEMENT ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")
  fi
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

echo $ELEMENT | (read TYPEID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT_PT BAR BOIL_PT BAR TYPE; echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_PT celsius and a boiling point of $BOIL_PT celsius.")
