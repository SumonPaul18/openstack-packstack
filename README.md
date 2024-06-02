# How to Build OpenStack Cloud using PackStack on Almalinux 9
#### 
### Login System Terminal as Root
####
Clone this Git Repository
####
    git clone https://github.com/SumonPaul18/build-openstack-packstack-almalinux9.git
    chmod -P +x build-openstack-packstack-almalinux9
    cd build-openstack-packstack-almalinux9
    ls
####
First execute pre-configure-openstack.sh Shell Script file for Preparing Installation OpenStack
####
    . pre-configuration-openstack.sh
The System has Rebooted
####
Second execute build-openstack.sh Shell Script file for Install OpenStack
####
    . build-openstack.sh
After Successfully Installation Complete
####
Third execute post-configuration-openstack.sh Shell Script file for OpenStack Basic Configuration on Network and Image services
####
    . post-configuration-openstack.sh
Now Successfully Configured OpenStack 
