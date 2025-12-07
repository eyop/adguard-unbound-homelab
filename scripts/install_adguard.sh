#!/bin/bash
# ======================================
# Install AdGuard Home
# For Debian 12 LXC/VM on Proxmox
# ======================================

# Download AdGuard Home
curl -s -S -L https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz -o adguard.tar.gz

# Extract
tar xvf adguard.tar.gz
cd AdGuardHome

# Install as service
./AdGuardHome -s install

echo "AdGuard Home installation complete. Web UI: http://<VM-IP>:3000"
