#!/bin/bash
#Configure Network in OpenStack by Cli

#Create OpenStack private Network.

openstack network create private

#Create subnet for private Network

openstack subnet create --network private \
--allocation-pool start=10.1.1.50,end=10.1.1.200 \
--dns-nameserver 8.8.8.8 --subnet-range 10.1.1.0/24 \
private_subnet

#Create a public network

openstack network create --provider-network-type flat \
--provider-physical-network extnet --external public

#Create subnet for public Network

echo -e "${bgreen}Subnet Create for Public Network ${nc} "
echo
read -p "LAN Network with CIDR (ex:192.168.x.x/24): " LAN_NETWORK
echo
read -p "DHCP-Pool Start IP: " START_IP
echo
read -p "DHCP-Pool End IP: " END_IP

openstack subnet create --network public \
--allocation-pool start=$START_IP,end=$END_IP \
--no-dhcp --subnet-range $LAN_NETWORK public_subnet

#Create a router and configure router interfaces

openstack router create --no-ha core-router

#Connect Interface with OpenStack Router

openstack router set --external-gateway public core-router

openstack router add subnet core-router private_subnet

ip netns show

#Upload Image on OpenStack Cloud

openstack image list

wget http://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

openstack image create --disk-format qcow2 \
--container-format bare --public \
--file jammy-server-cloudimg-amd64.img ubuntu

openstack image list


