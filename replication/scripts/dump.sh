#!/bin/bash

usage ()
{
    echo "Usage : $0 <OPERATION: restore | create> <HOSTNAME> <USERNAME> <PASSWORD> <DATABASE>";
    exit;
}

# Check if the number of arguments is correct
if [ "$#" -ne 5 ];
then
    usage;
fi

# Check if first argument is valid
if [ $1 -ne "restore" && $1 -ne "create" ];
then
    usage;
fi

# Store the arguments as connection variables
HOSTNAME=$2
USERNAME=$3
PASSWORD=$4
DATABASE=$5

# Realizes the operation according to the first argument
if [ $1 -eq "restore" ]
then
  mysql -h "$HOSTNAME" -u "$USERNAME" -p"$PASSWORD" "$DATABASE" < "dump.sql";
else
    if [ $1 -eq "create" ]
    then
        mysql -h "$HOSTNAME" -u "$USERNAME" -p"$PASSWORD" "$DATABASE" > "dump.sql";
    fi
fi
