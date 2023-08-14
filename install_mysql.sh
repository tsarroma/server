#!/bin/sh

PASSWORD='qwe123QWE!'
PASSWORD_SLAVE='qwe123QWE!'

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

echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '$PASSWORD'; FLUSH PRIVILEGES;" | mysql --connect-expired-password -uroot -p$pass

echo "CREATE USER 'root'@'%' IDENTIFIED BY '$PASSWORD'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;" |  mysql -uroot -p$PASSWORD

echo "SELECT User, Host FROM mysql.user\G;" |  mysql -uroot -p$PASSWORD

