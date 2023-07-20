#!/bin/bash

#Parameters for connect to MySQL server, not recomended, use ~/.my.cnf
MYSQL_USER='root' 
MYSQL_PASSWORD='qwe123QWE!'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
BACKUP_DIRECTORY="/var/backup/wordpress"

mkdir -pm 777 $BACKUP_DIRECTORY

MYSQL=$"-u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT"

#Create base
echo "CREATE DATABASE wordpress;" |  mysql $MYSQL 2>/dev/null 

#Create user
echo "CREATE USER wpuser@localhost IDENTIFIED BY '$MYSQL_PASSWORD'; GRANT ALL PRIVILEGES ON wordpress.* TO wpuser@localhost; FLUSH PRIVILEGES;" |  mysql $MYSQL

echo $TABLES

TABLES=$(ls /var/backup/wordpress/)

for TABLE in $TABLES; do
		gunzip < /var/backup/wordpress/$TABLE | mysql $MYSQL wordpress 2>/dev/null
done
