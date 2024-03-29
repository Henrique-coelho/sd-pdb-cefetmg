#!/bin/bash

DB_HOST="localhost"
DB_USER="aluno"
DB_PASS="123456"
DB_NAME="proteins_db"

TABLE_NAME="task"
COLUMN1_VALUE="$1"
COLUMN2_VALUE="$2"
COLUMN3_VALUE="$3"
COLUMN4_VALUE="$4"
COLUMN5_VALUE="$5"

update_mysql() {
    local query="UPDATE $TABLE_NAME SET task_status='$COLUMN2_VALUE', last_modification='$COLUMN3_VALUE' WHERE iteractions_id=$COLUMN1_VALUE AND system_id='$COLUMN4_VALUE' AND task_name='$COLUMN5_VALUE';"
    mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$query"
}

if [ $# -lt 3 ]; then
    echo "Erro: Faltam argumentos!"
    echo "Uso: $0 valor_coluna1 valor_coluna2 valor_coluna3"
    exit 1
fi

update_mysql
