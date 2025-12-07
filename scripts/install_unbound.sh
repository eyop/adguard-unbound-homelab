#!/bin/bash
# ======================================
# Install & configure Unbound DNS
# For Debian 12 LXC/VM on Proxmox
# ======================================

# Update system
apt update && apt upgrade -y

# Install Unbound
apt install unbound -y

# Backup default config
cp /etc/unbound/unbound.conf /etc/unbound/unbound.conf.bak

# Copy custom config (from repo)
cp ../configs/unbound.conf /etc/unbound/unbound.conf

# Enable and restart service
systemctl enable unbound
systemctl restart unbound

echo "Unbound installation complete. Listening on port 5335."
