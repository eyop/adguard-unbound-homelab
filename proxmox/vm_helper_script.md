
# 🖥 Proxmox VM/LXC Helper Script Guide

This guide provides commands and instructions to quickly provision **Unbound** and **AdGuard Home** VMs or LXCs on Proxmox VE for a self-hosted home DNS lab.

---

## ⚡ Requirements

* Proxmox VE 8.x installed and accessible via web UI or CLI
* Debian 12 ISO/template uploaded to Proxmox
* Basic knowledge of VM/LXC creation and networking

---

## 1️⃣ Create Unbound VM / LXC

**Specs:**

| Setting    | Value         |
| ---------- | ------------- |
| OS         | Debian 12     |
| CPU        | 1 core        |
| RAM        | 512 MB        |
| Disk       | 8–16 GB       |
| IP Address | 192.168.1.254 |
| Hostname   | unbound-home  |

**VM CLI Example (`qm`)**:

```bash
# Create VM 100
qm create 100 --name unbound-home --memory 512 --cores 1 --net0 virtio,bridge=vmbr0

# Import Debian 12 ISO
qm importdisk 100 /var/lib/vz/template/iso/debian-12.iso local-lvm

# Attach boot disk
qm set 100 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-100-disk-0

# Set boot order
qm set 100 --boot c --bootdisk scsi0

# Start VM
qm start 100
```

**LXC CLI Example (`pct`)**:

```bash
pct create 101 local:vztmpl/debian-12-standard_12.0-1_amd64.tar.gz \
  --hostname unbound-home --cores 1 --memory 512 \
  --net0 name=eth0,bridge=vmbr0,ip=192.168.1.254/24,gw=192.168.1.1 \
  --rootfs local-lvm:8

pct start 101
```

> ✅ After creation, SSH into the VM/LXC and run:
>
> ```bash
> bash /path/to/scripts/install_unbound.sh
> ```

---

## 2️⃣ Create AdGuard Home VM / LXC

**Specs:**

| Setting    | Value         |
| ---------- | ------------- |
| OS         | Debian 12     |
| CPU        | 1 core        |
| RAM        | 1 GB          |
| Disk       | 8–16 GB       |
| IP Address | 192.168.1.250 |
| Hostname   | adguard-home  |

**VM CLI Example (`qm`)**:

```bash
qm create 102 --name adguard-home --memory 1024 --cores 1 --net0 virtio,bridge=vmbr0

qm importdisk 102 /var/lib/vz/template/iso/debian-12.iso local-lvm

qm set 102 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-102-disk-0

qm set 102 --boot c --bootdisk scsi0

qm start 102
```

**LXC CLI Example (`pct`)**:

```bash
pct create 102 local:vztmpl/debian-12-standard_12.0-1_amd64.tar.gz \
  --hostname adguard-home --cores 1 --memory 1024 \
  --net0 name=eth0,bridge=vmbr0,ip=192.168.1.250/24,gw=192.168.1.1 \
  --rootfs local-lvm:8

pct start 102
```

> ✅ After creation, SSH into the VM/LXC and run:
>
> ```bash
> bash /path/to/scripts/install_adguard.sh
> ```

---

## 3️⃣ Networking Notes

* Both VMs/LXCs should be on the **same LAN bridge** (`vmbr0`) for internal connectivity.
* Use **static IPs** for DNS resolution.
* Optional: configure VLANs if segmenting IoT or guest networks.

---

## 4️⃣ Post-Setup Steps

1. Configure **AdGuard Home upstream DNS** to point to **Unbound (192.168.1.254:5335)**.
2. Set your **router’s LAN DNS** to AdGuard Home IP (`192.168.1.250`).
3. Test DNS resolution from any device:

```bash
nslookup openai.com 192.168.1.250
```

4. Optional: enforce DNS rules via firewall.

---

## 📌 Pro Tips

* LXCs are **lighter and faster** than full VMs—ideal for home labs.
* Use Proxmox **snapshots** before major changes for safe rollback.
* Document custom firewall rules and IP assignments in `network_map.md`.

---

This file is now **ready to go in your `proxmox/` folder** and complements the installation scripts and configs in your repo.

---
