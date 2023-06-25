#!/bin/bash

usage ()
{
    echo "Usage : $0 <MYSQL_USER> <MYSQL_PASSWORD>";
    exit;
}

if [ "$#" -ne 2 ];
then
    usage;
fi

# MySQL connection details
MYSQL_USER=$1
MYSQL_PASSWORD=$2

CREATE_DB="CREATE SCHEMA IF NOT EXISTS \`proteinDB\`;"

# Connect to MySQL and execute table creation query
echo $CREATE_DB | mysql -u "$1" -p"$2"