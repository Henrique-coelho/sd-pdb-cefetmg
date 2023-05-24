#!/bin/bash

DB_HOST="localhost"
DB_USER="user"
DB_PASS="password"
DB_NAME="dbName"

TABLE_NAME="Task"
COLUMN1_VALUE="$1"
COLUMN2_VALUE="$2"
COLUMN3_VALUE="$3"
COLUMN4_VALUE="$4"
COLUMN5_VALUE="$5"

insert_into_mysql() {
    local query="INSERT INTO $TABLE_NAME (interactions_id, task_Status, last_modification, system_id, task_name) VALUES ($COLUMN1_VALUE, '$COLUMN2_VALUE', '$COLUMN3_VALUE',$COLUMN4_VALUE,'$COLUMN5_VALUE');"
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$query"
}

if [ $# -lt 3 ]; then
    echo "Erro: Faltam argumentos!"
    echo "Uso: $0 valor_coluna1 valor_coluna2 valor_coluna3"
    exit 1
fi

insert_into_mysql
