# ☁️ Build Your Own OpenStack Cloud Using PackStack on AlmaLinux

![Install OpenStack](https://github.com/SumonPaul18/openstack-packstack/blob/main/images/InstallOpenStack.png)

This guide walks you through building an **OpenStack private cloud** on a **single-node AlmaLinux system** using **PackStack**. It includes pre-configuration, installation, and post-setup steps — designed for DevOps engineers, cloud learners, and IT professionals.

---

## ✅ What You'll Achieve

By the end of this guide, you will:

* Install OpenStack using PackStack
* Set up core services like Keystone (Identity), Glance (Image), Nova (Compute), Neutron (Networking), etc.
* Configure external networking and upload test images
* Access and manage your cloud via the Horizon dashboard (GUI)

---

## 🧾 System Requirements

| Resource | Minimum                 | Recommended                 |
| -------- | ----------------------- | --------------------------- |
| OS       | AlmaLinux 8 or later    | AlmaLinux 8 (latest update) |
| CPU      | 2 vCPUs                 | 4+ vCPUs                    |
| RAM      | 8 GB                    | 16 GB+                      |
| Disk     | 100 GB                  | 200 GB SSD                  |
| Access   | Root or sudo privileges | Root                        |

> ⚠️ PackStack is ideal for **proof of concept (PoC)** or **learning environments**, not production.

---

## 📦 Installation Overview

### 📁 Repo Contents

```bash
openstack-packstack/
├── pre-configuration-openstack.sh   # Prepares OS for OpenStack
├── install-openstack.sh             # Installs OpenStack using PackStack
└── post-configuration-openstack.sh  # Sets up default network, image, flavor
```

---

## 🔧 Step 1: System Pre-Configuration

Run the `pre-configuration-openstack.sh` script to:

* Install required packages
* Set hostname and configure the network
* Disable NetworkManager and firewalld
* Enable SELinux in permissive mode
* Add EPEL and OpenStack repos

### Commands

```bash
dnf install git -y
git clone https://github.com/SumonPaul18/openstack-packstack.git
chmod -R +x openstack-packstack
cd openstack-packstack
. pre-configuration-openstack.sh
```

> 🔄 The script will automatically **reboot** your system after configuration.

---

## 🏗️ Step 2: Install OpenStack with PackStack

After reboot, run the `install-openstack.sh` script to install OpenStack:

### Commands

```bash
cd /root/openstack-packstack
. install-openstack.sh
```

This will:

* Download and install all OpenStack components
* Generate an answer file (optional for customization)
* Configure the Horizon dashboard, Keystone, Glance, Nova, Neutron, etc.

> 📝 Installation may take **10–30 minutes** depending on your internet and system performance.

---

## ⚙️ Step 3: Post-Installation Configuration

After OpenStack is installed, use the `post-configuration-openstack.sh` script to:

* Source admin credentials
* Set up external and private networks
* Upload a test image (Cirros)
* Create default flavors

### Commands

```bash
cd /root
. keystonerc_admin
. /root/openstack-packstack/post-configuration-openstack.sh
```

---

## 🌐 Step 4: Access the OpenStack Dashboard

### 📌 Open your browser and navigate to:

```
http://<Your-OpenStack-Server-IP> or http://<your-domain>
```

> Example:
> `http://cloud.paulco.xyz`

### 🖥️ Login Page:

![OpenStack Login](https://github.com/SumonPaul18/openstack-packstack/blob/main/images/oplogin.png)

---

## 📊 Horizon Dashboard Overview

The Horizon dashboard provides a web-based interface to:

* Launch and manage instances
* Create networks and routers
* Manage volumes and images
* Create and assign users and projects

![OpenStack Dashboard](https://github.com/SumonPaul18/openstack-packstack/blob/main/images/opdash.png)

---

## 🧠 Tips & Best Practices

* Always **source `keystonerc_admin`** before running OpenStack CLI commands.
* You can customize PackStack by editing the **answer file** (`packstack --gen-answer-file=file.txt`).
* Use **Cockpit** or another tool to monitor system resources.
* For floating IPs, make sure your external network has access to your LAN or bridge interface.

---

## 📚 Useful Commands

| Description        | Command                       |
| ------------------ | ----------------------------- |
| List instances     | `openstack server list`       |
| List networks      | `openstack network list`      |
| List images        | `openstack image list`        |
| Create flavor      | `openstack flavor create ...` |
| Source credentials | `. keystonerc_admin`          |

---

## 🎥 Tutorials

📺 **Subscribe to my YouTube channel for step-by-step video tutorials:**
🔗 [Sumon Paul YouTube Channel](https://www.youtube.com/@cloudengineer187)

🎬 **Video Guides:**

* 🔹 [How to Install OpenStack on AlmaLinux using PackStack – Step-by-Step](https://youtu.be/kMxnd3gqYdg?list=PLb2ltiwnZ24xGWcrdjf8QC_Ac8dFBTBnZ) *(Replace with actual video link)*
* 🔹 [Adding New Compute Nodes on Existing OpenStack Cloud](https://youtu.be/vcKe_V0NLV8?list=PLb2ltiwnZ24xGWcrdjf8QC_Ac8dFBTBnZ)


> 🎯 More videos coming soon! Stay subscribed for DevOps, Cloud, and OpenStack content.

---

## 🔗 Official References

* 🌐 [OpenStack Docs](https://docs.openstack.org/)
* 📦 [PackStack Guide](https://docs.openstack.org/packstack/latest/)
* 📖 [OpenStack CLI](https://docs.openstack.org/python-openstackclient/latest/)

---

## 🙋‍♂️ Support

If you face any issues, feel free to:

* Open an issue in this repository
* Contact me at [LinkedIn](https://linkedin.com/in/sumonpaul18)
* 📧 Email: `sumonpaul461@gmail.com`

---

## 🎉 You're Ready to Explore the Cloud!

You've now built your own private cloud on AlmaLinux using PackStack — time to launch your first instance!

---

