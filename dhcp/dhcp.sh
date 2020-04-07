#!/bin/bash
# Written by David Serate
# Auto-installs DHCP services
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit 1
fi
if [[ ! $1 ]]; then
	echo "Please pass an argument, either -m for master server or -s for slave server."
	exit 1
fi
if [[ ! $@ =~ "-p" ]]; then
	exit 1
fi
cd /etc/dhcp/
mv dhcpd.conf dhcpd.conf.old
wget https://raw.githubusercontent.com/SirSertile/Group1.2-FinalProject-SYS265/master/dhcp/dhcpd.conf
# Parsing options for getopts 
while getopts "msp: " option; do
	case $option in
		m)
			# master do nothing
		;;
		s)
			# slave
			sed -i 's/primary/secondary/g'
		;;
		p)
			# peer thing
			sed -i "s/PADDRESS/$OPTARG/g"
			sed -i "s/SADDRESS/$(hostname -I)/g"
		;;
	esac
done
yum install dhcp
systemctl start dhcpd
systemctl enable dhcpd
firewall-cmd --add-port=647/tcp --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload