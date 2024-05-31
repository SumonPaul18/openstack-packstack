#!/bin/bash
#Configure Network in OpenStack by Cli

#Create subnet for private Network

openstack subnet create --network private \
--allocation-pool start=10.1.1.50,end=10.1.1.200 \
--dns-nameserver 8.8.8.8 --subnet-range 10.1.1.0/24 \
private_subnet

#Create a public network

openstack network create --provider-network-type flat \
--provider-physical-network extnet --external public

#Create subnet for public Network

openstack subnet create --network public \
--allocation-pool start=192.168.0.100,end=192.168.0.200 \
--no-dhcp --subnet-range 192.168.0.0/24 public_subnet

#Create a router and configure router interfaces

openstack router create --no-ha core-router

#Connect Interface with OpenStack Router

openstack router set --external-gateway public core-router

openstack router add subnet core-router private_subnet

ip netns show

#Upload Image on OpenStack Cloud

openstack image list


