# How to Build OpenStack Cloud using PackStack on Almalinux 9
#### 
![OpenStack](https://github.com/SumonPaul18/openstack-packstack/blob/main/images/InstallOpenStack.png)
#
## Step-1:
### Login Systems Terminal as Root

First execute `pre-configure-openstack.sh` Shell Script file for Preparing Installation OpenStack
####
    dnf install git -y
    git clone https://github.com/SumonPaul18/openstack-packstack.git
    chmod -R +x openstack-packstack
    cd openstack-packstack
    ls
    . pre-configuration-openstack.sh
####  
After Done Configuration the system has Rebooted
#
## Step-2:

Second execute `build-openstack.sh` Shell Script file for Install OpenStack
####
    cd /root/openstack-packstack
    . build-openstack.sh
After Successfully Installation Complete
#
## Step-3:
Third execute `post-configuration-openstack.sh` Shell Script file for OpenStack Basic Configuration on Network and Image services
####
    cd /root
    . keystonerc_admin
    . /root/openstack-packstack/post-configuration-openstack.sh
Now Successfully Configured OpenStack 

#### Now, Your Hits your `OpenStack Server IP` on Browser
