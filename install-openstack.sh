#!/bin/bash
bgreen='\033[1;32m'
red='\033[0;31m'
nc='\033[0m'
bold="\033[1m"
blink="\033[5m"
echo -e "${bgreen}Install OpenStack-PackStack on Almalinux ${nc} "
echo
echo
echo -e "${bgreen} System Information ${nc} "
echo
hostnamectl
echo
echo
read -p "$(echo -e "${bgreen}${bold}${blink}Type System Hostname: ${nc}")" hostname
hostnamectl set-hostname $hostname
ip a
echo
echo
echo -e "${bgreen}${bold}${blink} IP Information for Setup OVS Interface ${nc} "
read -p "Type static IP Interface Name: " STATIC_INTERFACE
read -p "Type static IP Address: " IP_ADDRESS
read -p "Type Your Domain Name: " DOMAIN_NAME
read -p "Type Your OpenStack Administrator Password: " apassword

echo -e "${bgreen} Enable PowerTools/CRB repository ${nc} "
dnf config-manager --set-enabled crb -y
dnf install epel-release -y
dnf install nano -y
dnf install centos-release-openstack-yoga -y
dnf clean all

echo "$IP_ADDRESS $hostname.$DOMAIN_NAME $hostname" >> /etc/hosts
echo
echo
hostname -f
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
systemctl disable firewalld
systemctl stop firewalld
#systemctl status NetworkManager
#systemctl disable NetworkManager
#systemctl stop NetworkManager
#systemctl restart network
ifup $STATIC_INTERFACE
dnf repolist
dnf update -y && dnf upgrade -y
systemctl daemon-reload
dnf install -y openstack-packstack -y
dnf repolist
dnf update -
packstack --version

#packstack --help

#Generate Answers

#Pre-Installation with Generate Answers file

packstack --os-neutron-ml2-tenant-network-types=vxlan \
--ntp-servers=0.asia.pool.ntp.org,1.asia.pool.ntp.org,2.asia.pool.ntp.org,3.asia.pool.ntp.org \
--os-neutron-ovs-bridge-interfaces=br-ex:$STATIC_INTERFACE \
--os-neutron-ml2-mechanism-drivers=openvswitch \
--os-neutron-ml2-type-drivers=vxlan,flat \
--os-neutron-l2-agent=openvswitch \
--keystone-admin-passwd=$apassword \
--provision-demo=n \
--os-heat-install=y \
--os-ceilometer-install=y \
--os-aodh-install=y \
--gen-answer-file /root/answers.txt

#Take Copy the answes file
cp /root/answers.txt /root/answers.copy.txt

#Installation OpenStack
packstack --answer-file /root/answers.txt | tee openstack-installation-log.txt

#To access Horizon Dashboard use the URL:

echo -e "${bgreen}http://$IP_ADDRESS/dashboard ${nc} "
