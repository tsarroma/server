#!/bin/sh

PASSWORD='qwe123QWE!'
MASTER_HOST='10.77.236.112'
MASTER_PASSWORD='qwe123QWE!'

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

echo "SELECT @@server_id; CREATE USER 'root'@'%' IDENTIFIED BY '$PASSWORD'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; GRANT REPLICATION SLAVE ON *.* TO 'root'@'%'; FLUSH PRIVILEGES" |  mysql -uroot -p$PASSWORD

#update index
systemctl stop mysqld

rm -f /var/lib/mysql/auto.cnf

echo "bind-address = 0.0.0.0" >> /etc/my.cnf
echo "server_id = 2" >> /etc/my.cnf

systemctl start mysqld

#cron backup
rsync -arvuP /tmp/server/crontab /etc/crontab
chmod 0644 /etc/cron.d/
systemctl restart crond.service
echo "add cron backup"
