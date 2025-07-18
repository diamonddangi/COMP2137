#!/bin/bash
# COMP2137 Assignment 2 Script
# Configures networking, installs Apache2 & Squid, creates user with SSH and sudo

set -e

echo "==== Starting Assignment 2 Configuration ===="

# --- Network Configuration ---
echo "==== Configuring Netplan ===="
cat <<EOF > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    enp0s3:
      addresses:
        - 192.168.16.21/24
      gateway4: 192.168.16.2
      nameservers:
        addresses: [192.168.16.1]
EOF

netplan apply

# --- Software Installation ---
echo "==== Installing Apache2 and Squid ===="
apt update
apt install -y apache2 squid

systemctl enable apache2
systemctl restart apache2
systemctl enable squid
systemctl restart squid

# --- Create User and Configure SSH ---
echo "==== Creating user student ===="
if ! id -u student >/dev/null 2>&1; then
    useradd -m student
fi

mkdir -p /home/student/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTrWpHxXZGmeh6y4ppM0X9i2BKRKMOkLDwD8L8Xmi8X diamond@generic-vm" > /home/student/.ssh/authorized_keys

chown -R student:student /home/student/.ssh
chmod 700 /home/student/.ssh
chmod 600 /home/student/.ssh/authorized_keys

usermod -aG sudo student

echo "==== Assignment 2 Configuration Complete ===="
