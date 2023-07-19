#!/bin/sh

PASSWORD='qwe123QWE!'

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
echo "SELECT @@server_id; CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'oTUSlave#2020'; GRANT REPLICATION SLAVE ON *.* TO repl@'%'; FLUSH PRIVILEGES; SELECT User, Host FROM mysql.user; FLUSH TABLES WITH READ LOCK; SHOW MASTER STATUS;" |  mysql -uroot -p$PASSWORD

#Reboot
read -p "Reboot now (y/n)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
	exit 1
fi
