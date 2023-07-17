#!/bin/sh

#Disable SeLinux
sudo sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config
echo "SeLinux disabled after reboot"

#Set hostname
HOSTNAME=mysql-master
hostnamectl set-hostname $HOSTNAME
systemctl restart systemd-hostnamed

#Set network and backup last

UUID=`cat /etc/sysconfig/network-scripts/ifcfg-e* | awk -F "=" '/UUID/ {print $2}'`
DEVICE=`cat /etc/sysconfig/network-scripts/ifcfg-e* | awk -F "=" '/DEVICE/ {print $2}' | sed 's/\"//g'`
yes | cp /etc/sysconfig/network-scripts/ifcfg-e* /etc/sysconfig/network-scripts/ifcfg-$DEVICE.back

echo "TYPE=\"Ethernet\"
PROXY_METHOD=\"none\"
BROWSER_ONLY=\"no\"
BOOTPROTO=\"static\"
IPADDR=10.77.236.112
NETMASK=255.255.255.0
GATEWAY=10.77.236.1
DNS1=8.8.8.8
DNS2=8.8.4.4
DEFROUTE=\"yes\"
IPV4_FAILURE_FATAL=\"no\"
IPV6INIT=\"yes\"
IPV6_AUTOCONF=\"yes\"
IPV6_DEFROUTE=\"yes\"
IPV6_FAILURE_FATAL=\"no\"
IPV6_ADDR_GEN_MODE=\"stable-privacy\"
NAME=\"$DEVICE\"
UUID=$UUID
DEVICE=\"$DEVICE\"
ONBOOT=\"yes\"
">/etc/sysconfig/network-scripts/ifcfg-$DEVICE

systemctl restart network

#Disable firewalld
systemctl disable --now firewalld

#Reboot
read -p "Reboot now (y/n)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
	exit 1
fi
