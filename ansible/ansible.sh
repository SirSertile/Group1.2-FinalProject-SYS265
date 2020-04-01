#!/bin/bash
# Written by David Serate
# Auto-installs Ansible
# Probably broken
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
while getopts "is: " option; do
	val=$OPTARG
	case $option in
		i)
			apt-add-repository ppa:ansible/ansible -y
			apt-get update -y
			apt-get install sshpass ansible python-pip python-setuptools -y
			pip install wheel pywinrm pywinrm[kerberos]
			ssh-keygen -t rsa
			exit 0
		;;
		s)
			ssh-copy-id /home/deployer/.ssh/id_rsa.pub deployer@$val
		;;
	esac
done