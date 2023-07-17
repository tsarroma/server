#!/bin/sh

#update utilities
yum update -y

#install utilities
yum -y install mc nano epel-release 

#install apache nginx
yum -y install nginx apache

#start and startup service nginx apache
systemctl enable --now nginx
systemctl enable --now httpd

#Reboot
read -p "Reboot now (y/n)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
	exit 1
fi
