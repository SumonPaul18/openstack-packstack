#!/bin/bash

# Color constants (optional)
bgreen='\033[1;32m'
red='\033[0;31m'
nc='\033[0m'

# Function for colored echo (optional)
function cecho() {
  echo -e "${bgreen}<span class="math-inline">1</span>{nc}"
}

# Set hostname (uncomment if desired)
# echo -e "${bgreen}Type Hostname: <span class="math-inline">\{nc\}"
\# read hostname
cecho "\*\* Setting Up Static IP Address \*\*"
\# Read user input for network configuration
read \-p "</span>(cecho "Type System Hostname: ") " hostname
hostnamectl set-hostname "$hostname"

cecho "** Enabling PowerTools/CRB Repository **"

dnf install dnf-plugins-core -y
dnf config-manager --set-enabled crb -y
dnf install epel-release -y

# AlmaLinux 9 uses the Yoga OpenStack release
dnf install centos-release-openstack-yoga -y

dnf clean all
yum clean all  # Compatibility for commands using 'yum'

# Network Configuration

cecho "** Network Settings **"

read -p "Type static IP Interface Name: " STATIC_INTERFACE
read -p "Type MAC for static Interface (optional): " MAC_Address
read -p "Type static IP Address with CIDR: " IP_ADDRESS
read -p "Type Gateway: " GATEWAY
read -p "Type 1st DNS: " DNS
read -p "Type 2nd DNS (optional): " DNS2

# Improved network configuration with comments and variable usage
cat <<EOF | sudo tee /etc/sysconfig/network-scripts/ifcfg-<span class="math-inline">STATIC\_INTERFACE
\# Hardware Address \(optional\)
HWADDR\=</span>{MAC_Address}

NM_CONTROLLED=no
BOOTPROTO=static
ONBOOT=yes

# IP Configuration
IPADDR=$IP_ADDRESS
PREFIX=24
GATEWAY=$GATEWAY
DNS1=<span class="math-inline">DNS
\# Optional secondary DNS
DNS2\=</span>{DNS2}

DEVICE=$STATIC_INTERFACE
EOF

# Apply network changes
nmcli connection up "$STATIC_INTERFACE" || true  # Attempt using nmcli, handle potential errors
systemctl restart network

# Verify network configuration (optional)
ip a

# Update hostname in /etc/hosts
echo "$IP_ADDRESS $hostname.paulco.xyz $hostname" >> /etc/hosts

# Disable SELinux (consider security implications)
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Disable and stop firewalld
systemctl disable firewalld
systemctl stop firewalld

# Network service management (consider using NetworkManager for easier management)
# systemctl status NetworkManager
systemctl disable NetworkManager
systemctl stop NetworkManager

# Ensure static interface is brought up (may not be necessary with nmcli)
ifup "$STATIC_INTERFACE"

# Remove unnecessary packages
yum autoremove epel-release

# Ensure OpenStack packages are not pre-installed
yum autoremove openstack-packstack

# Clean package cache
yum clean all

# Update system packages
yum repolist
yum update -y && yum upgrade -y

# Install OpenStack Packstack

dnf config-manager --set-enabled crb

# AlmaLinux 9 uses the Yoga OpenStack release
dnf install centos-release-openstack-yoga -y

yum install -y openstack-packstack

yum repolist
yum update -y

# Verify Packstack installation
packstack --version
packstack --help

# Generate OpenStack Packstack answer file

read -p "Type Your OpenStack Administrator Password: " apassword

# Improved answer file generation with comments and variable usage
packstack --os-neutron-ml2-tenant-network-types=vxlan \
         --os-neutron-ovs-bridge-interfaces=br-ex:$STATIC_INTERFACE \
         --os-neutron-ml2-mechanism-drivers=openvswitch \
         --os-neutron-ml2-type-drivers=vxlan,flat \
         --os-neutron-l2-agent=openvswitch \
         --keystone-admin-passwd=$apassword \
         --provision-demo=n \
         --os-heat-install=y \
         --gen-answer-file /root/answers.txt

# Backup answer file (optional)
cp /root/answers.txt /root/copy

