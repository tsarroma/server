#!/bin/sh

PASSWORD='qwe123QWE!'
MASTER_HOST='10.77.197.112'
MASTER_PASSWORD='oTUSlave#2020'

#install repo Oracle MySQL 8.0
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-7.noarch.rpm

#Enable repo
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo

#Install MySQL
yum --enablerepo=mysql80-community install -y mysql-community-server

#Start and starup service mysqld
systemctl enable --now mysqld

#Temp passwd
pass=$(grep "A temporary password" /var/log/mysqld.log | awk '{print $NF}')

echo $pass

echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '$PASSWORD'; FLUSH PRIVILEGES;" | mysql --connect-expired-password -uroot -p$pass
echo "SELECT @@server_id; CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY '$MASTER_PASSWORD'; GRANT REPLICATION SLAVE ON *.* TO repl@'%'; FLUSH PRIVILEGES; SELECT User, Host FROM mysql.user; FLUSH TABLES WITH READ LOCK; SHOW MASTER STATUS;" |  mysql -uroot -p$PASSWORD

#update index
rf -f /var/lib/mysql/auto.cnf

echo "server_id = 2" >> /etc/my.cnf
echo "innodb_read_only = 1" >> /etc/my.cnf

systemctl restart mysqld

echo "SELECT User, Host FROM mysql.user\G; SHOW MASTER STATUS\G; SHOW GLOBAL VARIABLES LIKE 'caching_sha2_password_public_key_path'; SHOW STATUS LIKE 'Caching_sha2_password_rsa_public_key'\G" |  mysql -uroot -p$PASSWORD

echo "STOP SLAVE; CHANGE MASTER TO MASTER_HOST='$MASTER_HOST', MASTER_USER='repl', MASTER_PASSWORD='$MASTER_PASSWORD', MASTER_LOG_FILE='binlog.000005', MASTER_LOG_POS=688, GET_MASTER_PUBLIC_KEY = 1; START SLAVE; show slave status\G" |  mysql -uroot -p$PASSWORD

#Reboot
read -p "Reboot now (y/n)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
	exit 1
fi
