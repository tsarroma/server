#!/bin/bash

#install utilities
yum -y install mc nano epel-release 

#install apache nginx
yum -y install nginx apache

#start and startup service nginx apache
systemctl enable --now nginx
systemctl enable --now httpd

#wordpress install
cd /tmp
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads
sudo chown -R apache:apache /var/www/html/*
cd /var/www/html
cp wp-config-sample.php wp-config.php


#Copy configs nginx apache
cp -r ./httpd/* /etc/httpd
cp -r ./nginx/* /etc/nginx


#set configs
nginx -s reload
httpd -t


