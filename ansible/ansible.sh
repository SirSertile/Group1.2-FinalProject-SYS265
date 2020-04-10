#!/bin/bash
# Written by David Serate
# Auto-installs Ansible
# Probably broken
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
while getopts "is:d " option; do
	val=$OPTARG
	case $option in
		i)
			# installs the repositiories in apt
			apt-add-repository ppa:ansible/ansible -y
			apt-get update -y
			apt-get install sshpass ansible python-pip python-setuptools -y
			pip install wheel pywinrm pywinrm[kerberos]
			ssh-keygen -t rsa -f id_rsa
			mkdir -p ansible/roles
			touch ansible/roles/inventory.txt
			exit 0
		;;
		s)	
			# sets up deployer remotely
			script='sudo adduser deployer;
			sudo echo -e "deployer \t ALL=(ALL) \t NOPASSWD:ALL" | sudo tee /etc/sudoers.d/deployer'
			ssh -tt -o StrictHostKeyChecking=no -l $(logname) $val "$script"
			# copies SSH ID
			ssh-copy-id -i /home/$(logname)/id_rsa.pub deployer@$val
		;;
		d)
			# sets up deployer account
			adduser deployer
			echo -e "deployer \t ALL=(ALL) \t NOPASSWD:ALL" | tee /etc/sudoers.d/deployer
		;;
	esac	
done