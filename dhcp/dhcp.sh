#!/bin/bash
# Written by David Serate
# Auto-installs DHCP services
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /etc/dhcp/
wget https://raw.githubusercontent.com/SirSertile/Group1.2-FinalProject-SYS265/master/dhcp/dhcpd.conf
yum install dhcp
systemctl start dhcpd
systemctl enable dhcpd
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload