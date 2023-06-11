#!/bin/bash

# ---------- CONFIGURAÇÕES INICIAIS ----------

# Verifica se os parametros foram passados corretamente
if [ $# -lt 7 ]; then
    echo "Usage: $0 <BACKUP_LOCAL> <BACKUP_REMOTE> <USER_REMOTE> <HOST_REMOTE> <USER_LOCAL> <PASSWORD> <BD_BASE>\n"
    exit 1
fi

# Diretorio para backup
BACKUP_LOCAL=$1
BACKUP_REMOTE=$2

# Usuario e host remoto
DESTINE=$3+"@"+$4

HOST=$(hostname)

# Usuario com permissoes no MySQL local
USER=$5
PASSWORD=$6

# Nome da base onde esta o banco
BD_BASE=$7

# Periodo de armazenamento local
DAYS="7"

DATE=`date +%Y%m%d_%H%M%S`

# ---------- LIMPEZA ----------
if [ ! -d ${BACKUP_LOCAL} ]; then
	echo ""
	echo " A pasta de backup nao foi encontrada!"
	echo " Criando pasta... "
	mkdir -p ${BACKUP_LOCAL}
	echo ""
else
	echo ""
	echo " Limpando backups mais antigos que $DAYS"
	echo ""

	find ${BACKUP_LOCAL} -type d -mtime +$DAYS -exec rm -rf {} \;
fi

# ---------- SCRIPT ----------

# Cria estrutura local
if [ ! -d $BACKUP_LOCAL/$DATE/mysql ]; then
        mkdir -p $BACKUP_LOCAL/$DATE/mysql
fi

# Faz o backup de um BD específico
for database in `/usr/bin/mysql -u $USER -p$PASSWORD --execute="show databases;" | grep $BD_NAME`; do
        /usr/bin/mysqldump -u $USER --password=$PASSWORD --databases $database > $BACKUP_LOCAL/$DATE/mysql/$database.txt
        cd $BACKUP_LOCAL/$DATE/mysql/
        tar -czvf $database.tar.gz $database.txt
        # Checa integridade 
	sha1sum $database.tar.gz > $database.sha1	
        rm -rf $database.txt
	cd /
done

# Faz o backup de todos os BDs aos domingos
DAYOFWEEK=$(date +"%u")
if [ "${DAYOFWEEK}" -eq 7  ];  then
  # Todas as bases
  /usr/bin/mysqldump -p -u ${USER} --password=${PASSWORD} --all-databases  > ${BACKUP_LOCAL}/${DATE}/mysql/mysql_all.txt
   cd ${BACKUP_LOCAL}/${DATE}/mysql/
   tar -czvf mysql_all.tar.gz mysql_all.txt
   sha1sum mysql_all.tar.gz > mysql_all.sha1
   rm -f mysql_all.txt
fi

cd /

# Faz o backup de usuários
/usr/bin/mysqldump -u $USER --password=$PASSWORD --no-create-info  mysql user > $BACKUP_LOCAL/$DATE/mysql/users.sql

# Faz o backup de permissões
/usr/bin/mysql -u $USER --password=$PASSWORD --skip-column-names -A -e"SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') FROM mysql.user WHERE user<>''" | mysql -u $USER --password=$PASSWORD --skip-column-names -A | sed 's/$/;/g' > $BACKUP_LOCAL/$DATE/mysql/grants.sql

# Faz uma conexão SSH para criar a estrutura remota
# verificando se existe um diretorio com o nome do host local no host remoto
if [ $(ssh  $DESTINE "ls ${BACKUP_REMOTE}" |grep -i $HOST |wc -l) = 0 ]; then
        ssh  $DESTINE "mkdir -p ${BACKUP_REMOTE}/$HOST"
fi

# Copiar para o host de destino os dumps gerados localmente
scp -o StrictHostKeyChecking=no -r $BACKUP_LOCAL/$DATE $DESTINE:${BACKUP_REMOTE}/$HOST/
