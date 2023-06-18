#!/bin/bash

usage ()
{
    echo "Usage : $0 <HOSTNAME> <USERNAME> <PASSWORD> <DATABASE>";
    exit;
}

# Check if the number of arguments is correct
if [ "$#" -ne 4 ];
then
    usage;
fi

# Store the arguments as connection variables
HOSTNAME=$1
USERNAME=$2
PASSWORD=$3
DATABASE=$4

mysql -h "$HOSTNAME" -u "$USERNAME" -p"$PASSWORD" "$DATABASE" < "dump.sql"