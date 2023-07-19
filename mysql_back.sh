#!/bin/bash

#####
#Script for backup MySQL databases and tables with set parameters in script 
#####

#Parameters for connect to MySQL server, not recomended, use ~/.my.cnf
MYSQL_USER="repl" 
MYSQL_PASSWORD="oTUSlave#2020"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"

#Parameters for backup
SELECT_DATABASE=".*_db$" #For select all databases input ""
SELECT_TABLE=".*_tbl.*" #For select all tables in databases input "" 
BACKUP_DIRECTORY="/var/backup/mysql" #Set backup directory

#Test connect to MySQL server with ~./my.cnf or input parameters for connect
if [[ `mysql -e "SHOW DATABASES" 2> /dev/null | grep Database` == Database ]]; then
 	MYSQL=""
else
  	MYSQL=$"-u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT"
fi

#Test set varible SELECT_DATABASE or backup all databases except service
if [[ -z $SELECT_DATABASE ]]; then
	DB="egrep -v '_schema|sys|mysql'"
else
	DB="egrep "$SELECT_DATABASE""
fi

#Get list of databases
BASES=$(mysql -D mysql --skip-column-names -B $MYSQL -e 'SHOW DATABASES;' 2> /dev/null | $DB)

echo "stop slave;" | mysql $MYSQL

#Main cycle of script, 
for BASE in $BASES; do
	if [[ -z $SELECT_TABLE ]]; then #Test set varible SELECT_TABLE or backup all tables
		TBL="egrep -v '^Tables'"
	else
		TBL="egrep "$SELECT_TABLE""
	fi

	TABLES=$(mysql $MYSQL -e "USE $BASE; SHOW TABLES;" 2> /dev/null | awk '{ print $1}' | $TBL) #Get list of tables in databases
	
	for TABLE in $TABLES; do
		mkdir -p $BACKUP_DIRECTORY/$BASE/
		mysqldump $MYSQL --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --default-character-set=utf8 --events --routines --triggers --master-data=2 $BASE $TABLE 2> /dev/null | gzip -1 > $BACKUP_DIRECTORY/$BASE/$TABLE.sql.gz
		if [[ -f $BACKUP_DIRECTORY/$BASE/$TABLE.sql.gz ]]; then
			echo "$BACKUP_DIRECTORY/$BASE/$TABLE.sql.gz - backup success!"
		fi
	done
done

echo "start slave;" | mysql $MYSQL
