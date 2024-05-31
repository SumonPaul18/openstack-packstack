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

systemctl start network
systemctl enable network

# Verifying IP & MAC Addresses
ip a

echo
echo

echo -e "${bgreen}${bold}${blink} Network Settings ${nc} "

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

#reboot

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

