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
mkdir -p /var/www/html1
mkdir -p /var/www/html2
mkdir -p /var/www/html3
rsync -avP ./wordpress/ /var/www/html1/
rsync -avP ./wordpress/ /var/www/html2/
rsync -avP ./wordpress/ /var/www/html3/
mkdir -p /var/www/html1/wp-content/uploads
mkdir -p /var/www/html2/wp-content/uploads
mkdir -p /var/www/html3/wp-content/uploads
sudo chown -R apache:apache /var/www/html1/*
sudo chown -R apache:apache /var/www/html2/*
sudo chown -R apache:apache /var/www/html3/*
cd /tmp/server/www/html1
cp -rf ./wp-config.php /var/www/html1/wp-config.php
cd /tmp/server/www/html2
cp -rf ./wp-config.php /var/www/html2/wp-config.php
cd /tmp/server/www/html3
cp -rf ./wp-config.php /var/www/html3/wp-config.php

#Copy configs nginx apache
cd /tmp/server/
cp -rf ./httpd/* /etc/httpd
cp -rf ./nginx/* /etc/nginx

#Restart web services
systemctl restart httpd
systemctl restart nginx

#Avaible ports
ss -tlpn

#set configs
nginx -s reload
httpd -t

#Install monitoring
cd /tmp
wget -I *.tar.gz
yum install -y prometheus*.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar xzvf *.tar.gz 
yum install -y https://dl.grafana.com/oss/release/grafana-10.0.2-1.x86_64.rpm
