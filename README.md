# 🚀 How to Build OpenStack Cloud using PackStack on AlmaLinux
#### 
![OpenStack](https://github.com/SumonPaul18/openstack-packstack/blob/main/images/InstallOpenStack.png)
---

This guide will help you set up OpenStack Cloud on AlmaLinux using PackStack in just a few steps. Whether you're a beginner or a cloud enthusiast, follow these steps to build your private cloud easily.

#### 📋 Prerequisites
- Fresh AlmaLinux OS (Tested on AlmaLinux 8+)
- Root privileges
- Internet connectivity
- At least 16 GB RAM (Recommended)
- Virtualization supported CPU

### 🛠️ Step 1: Pre-Configuration
Login to your terminal as root and prepare the system by running the pre-configuration script.

First execute `pre-configure-openstack.sh` Shell Script file for Preparing Installation OpenStack
####
    dnf install git -y
    git clone https://github.com/SumonPaul18/openstack-packstack.git
    chmod -R +x openstack-packstack
    cd openstack-packstack
    ls
    . pre-configuration-openstack.sh
####  
🔁 The system will reboot automatically after completing the pre-configuration.

---
### 🔧 Step 2: Install OpenStack with PackStack
After the reboot, execute the installation script to install OpenStack:
####
    cd /root/openstack-packstack
    . install-openstack.sh
✅ This step installs OpenStack and sets up the necessary services using PackStack.

---
### 🔌 Step 3: Post-Configuration
Once OpenStack is installed, configure basic networking and image services:
####
    cd /root
    . keystonerc_admin
    . /root/openstack-packstack/post-configuration-openstack.sh
📦 This script will set up an external network, flavors, and default images.

### 🌐 Access OpenStack Dashboard
Once everything is configured, open your browser and visit:
```
http://<Your-OpenStack-Server-IP>
```

### 🔐 OpenStack Login Page
#### In my Case, I has Pointed a Domain `cloud.paulco.xyz` with my OpenStack Server IP:
![OpenStack Login](https://github.com/SumonPaul18/openstack-packstack/blob/main/images/oplogin.png)

### 📊 OpenStack Dashboard Overview
![OpenStack Dashboard](https://github.com/SumonPaul18/openstack-packstack/blob/main/images/opdash.png)

### 🙌 You're Done!
Congratulations! You have successfully installed and configured OpenStack Cloud on AlmaLinux using PackStack. You can now start launching instances, managing users, and exploring OpenStack services through the Horizon dashboard.

