#!/bin/bash

# Add Stack User (optional)
sudo useradd -s /bin/bash -d /opt/stack -m stack

sudo chmod +x /opt/stack

echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

sudo -u stack -i
mkdir -p /opt/stack/logs/

# RedHat Flavor Instructions
sudo dnf install httpd -y
sudo dnf install mod_proxy_uwsgi -y
sudo dnf install wget -y
sudo dnf install iptables-services -y
sudo dnf install git -y
sudo dnf install -y iscsi-initiator-utils
sudo dnf install virt-manager libvirt qemu-kvm qemu-img -y
sudo dnf install memcached -y 
sudo dnf install -y mod_wsgi
sudo dnf install -y mariadb-server -y


git clone https://opendev.org/openstack/devstack

cd devstack

vi local.conf

ADMIN_PASSWORD=OSpass2023
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD

# Start the Installation
./stack.sh
systemctl enable openvswitch.service
systemctl start openvswitch
sudo systemctl status network
sudo systemctl start network.service
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I OUTPUT -p tcp --sport 80 -j ACCEPT

sudo vi /etc/rc.local
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I OUTPUT -p tcp --sport 80 -j ACCEPT

# Ubuntu Flavor Instructions
sudo apt install apache2 -y
sudo systemctl enable apache2.service
sudo systemctl start apache2
sudo apt install virt-manager qemu-kvm -y
sudo apt install memcached -y 
sudo systemctl enable memcached.service
sudo systemctl start memcached
sudo apt install mysql-server -y 
sudo systemctl enable mysql.service
sudo systemctl start mysql

sudo mysql -uroot -p
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'StrongAdminSecret';
flush privileges;
mysql -uroot -p 

git clone https://opendev.org/openstack/devstack

cd devstack

vi local.conf

[[local|localrc]]

# Password for KeyStone, Database, RabbitMQ and Service
ADMIN_PASSWORD=StrongAdminSecret
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD

# Host IP - get your Server/VM IP address from ip addr command
HOST_IP=172.31.21.195

# Start the Installation
./stack.sh