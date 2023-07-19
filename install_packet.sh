#!/bin/sh

#update utilities
yum update -y

#install utilities
yum -y install mc nano epel-release 

#install apache nginx
yum -y install nginx apache

#Copy configs nginx apache 
cp -r ./httpd/* /etc/httpd
cp -r ./nginx/* /etc/nginx

#start and startup service nginx apache
systemctl enable --now nginx
systemctl enable --now httpd

#set configs
nginx -s reload
httpd -t


#Reboot
read -p "Reboot now (y/n)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
	exit 1
fi
