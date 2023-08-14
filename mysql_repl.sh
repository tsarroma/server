#!/bin/bash

#Parameters for connect to MySQL server, not recomended, use ~/.my.cnf
MYSQL_USER='root' 
PASSWORD='qwe123QWE!'

read -p "Enter MASTER_LOG_FILE='binlog." MASTER_LOG_FILE
read -p "Enter MASTER_LOG_POS=" MASTER_LOG_POS

echo "STOP SLAVE; CHANGE MASTER TO MASTER_HOST='10.77.236.112', MASTER_USER='root', MASTER_PASSWORD='qwe123QWE!', MASTER_LOG_FILE=binlog.'$MASTER_LOG_FILE', MASTER_LOG_POS='$MASTER_LOG_POS', GET_MASTER_PUBLIC_KEY = 1; START SLAVE; show slave status\G" |  mysql -uroot -p$PASSWORD

