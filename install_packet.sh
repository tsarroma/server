#!/bin/bash

#install utilities
yum install -y mc nano epel-release wget yum-utils

#install apache nginx
yum install -y nginx httpd

#start and startup service nginx apache
systemctl enable --now nginx
systemctl enable --now httpd

#Php install
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php74
yum install -y php php-mysqli php-xml

#wordpress install
cd /tmp
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

#cycle for cloning instance
for (( i = 1; i < 4; i++ )); do
	mkdir -p /var/www/html$i
  rsync -avP ./wordpress/ /var/www/html$i/
	mkdir -p /var/www/html$i/wp-content/uploads
  sudo chown -R apache:apache /var/www/html$i/*
  cd /tmp/server/www/html$i
  cp -rf ./wp-config.php /var/www/html$i/wp-config.php
done

#Copy configs nginx apache
cd /tmp/server/
cp -rf ./httpd/* /etc/httpd
cp -rf ./nginx/* /etc/nginx

#Restart web services
systemctl restart httpd
echo "httpd"
systemctl is-active httpd

systemctl restart nginx
echo "nginx"
systemctl is-active nginx

#Avaible ports
ss -tlpn

#set configs
nginx -s reload
httpd -t

