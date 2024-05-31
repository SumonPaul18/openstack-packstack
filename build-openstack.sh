#!/bin/bash
bgreen='\033[1;32m'
red='\033[0;31m'
nc='\033[0m'
bold="\033[1m"
blink="\033[5m"
echo -e "${bgreen}Install OpenStack-PackStack on Almalinux 9 ${nc} "

#Install & Configure OpenStack-PackStack

#For AlmaLinux 9

#dnf config-manager --set-enabled crb -y

#Working On AlmaLinux 9
#dnf install centos-release-openstack-yoga -y

dnf install -y openstack-packstack -y

dnf repolist

dnf update -y

packstack --version

#packstack --help

#Generate Answers

#Pre-Installation with Generate Answers file

# Verifying IP & MAC Addresses
ip a

echo
echo

read -p "Type static IP Interface Name: " STATIC_INTERFACE

read -p "Type Your OpenStack Administrator Password: " apassword

packstack --os-neutron-ml2-tenant-network-types=vxlan \
--ntp-servers=0.asia.pool.ntp.org,1.asia.pool.ntp.org,2.asia.pool.ntp.org,3.asia.pool.ntp.org \
--os-neutron-ovs-bridge-interfaces=br-ex:$STATIC_INTERFACE \
--os-neutron-ml2-mechanism-drivers=openvswitch \
--os-neutron-ml2-type-drivers=vxlan,flat \
--os-neutron-l2-agent=openvswitch \
--keystone-admin-passwd=$apassword \
--provision-demo=n \
--os-heat-install=y \
--gen-answer-file /root/answers.txt


#Take Copy the answes file
cp /root/answers.txt /root/answers.copy.txt

#Installation OpenStack
packstack --answer-file /root/answers.txt | tee openstack-installation-log.txt

#To access Horizon Dashboard use the URL:

echo -e "${bgreen}http://$IP_ADDRESS/dashboard ${nc} "
