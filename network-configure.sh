#!/bin/bash
bgreen='\033[1;32m'
red='\033[0;31m'
nc='\033[0m'
bold="\033[1m"
blink="\033[5m"
echo -e "${bgreen}Install OpenStack-PackStack on Almalinux 9 ${nc} "

# Set Hostname
#echo -e "${bgreen}Type Hostname : ${nc}"
#read hostname

echo
echo

read -p "$(echo -e "${bgreen}${bold}${blink}Type System Hostname: ${nc}")" hostname

hostnamectl set-hostname $hostname

echo -e "${bgreen} Enable PowerTools/CRB repository ${nc} "

#dnf install dnf-plugins-core -y
dnf config-manager --set-enabled crb -y
dnf install epel-release -y
dnf install nano -y
#sudo dnf install https://www.rdoproject.org/repos/rdo-release.el9.rpm -y
#dnf install centos-release-openstack-antelope -y
#dnf install centos-release-openstack-zed -y
#dnf install centos-release-openstack-bobcat -y
dnf install centos-release-openstack-yoga -y

dnf clean all
#dnf clean all
#dnf update -y

dnf install network-scripts -y

ls /etc/sysconfig/network-scripts/

#systemctl status network
systemctl start network
systemctl enable network

# Verifying IP & MAC Addresses
ip a

echo
echo

echo -e "${bgreen}${bold}${blink} Configure Static IP ${nc} "

read -p "Type static IP Interface Name: " STATIC_INTERFACE
read -p "Type MAC for static Interface: " MAC_ADDRESS
read -p "Type static IP Address: " IP_ADDRESS
read -p "Type IP PREFIX (CIDR): " IP_PREFIX
read -p "Type Gateway4: " GATEWAY
read -p "Type 1st DNS: " DNS
read -p "Type 2nd DNS: " DNS2

cat <<EOF | sudo tee /etc/sysconfig/network-scripts/ifcfg-$STATIC_INTERFACE
HWADRR=$MAC_ADDRESS
NM_CONTROLLED=no
BOOTPROTO=static
ONBOOT=yes
IPADDR=$IP_ADDRESS
PREFIX=$IP_PREFIX
GATEWAY=$GATEWAY
DNS1=$DNS
DNS2=$DNS2
DEVICE=$STATIC_INTERFACE

EOF

# Apply the Netplan configuration
nmcli connection up $STATIC_INTERFACE

ip a s $STATIC_INTERFACE

systemctl restart NetworkManager

ifup $STATIC_INTERFACE

cp /etc/sysconfig/network-scripts/ifcfg-$STATIC_INTERFACE /etc/sysconfig/network-scripts/ifcfg-$STATIC_INTERFACE.bak

cat /etc/sysconfig/network-scripts/ifcfg-$STATIC_INTERFACE

echo "$IP_ADDRESS $hostname.paulco.xyz $hostname" >> /etc/hosts

echo
echo

hostname -f

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

systemctl disable firewalld
systemctl stop firewalld

#systemctl status NetworkManager
systemctl disable NetworkManager
systemctl stop NetworkManager

systemctl restart network

ifup $STATIC_INTERFACE

#dnf autoremove epel-release -y

#dnf autoremove openstack-packstack -y
 
#dnf clean all

dnf repolist

dnf update -y && dnf upgrade -y

reboot
