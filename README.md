
# 🏠 AdGuard + Unbound HomeLab on Proxmox

A **self-hosted, privacy-focused DNS infrastructure** running on Proxmox VE using:

* **AdGuard Home** – Network-level ad blocker
* **Unbound** – Secure recursive DNS resolver
* **Proxmox VE** – Virtualization host for VMs or LXCs
* **Router & LAN Devices** – Your home network

This project allows **ad-free, secure, and fast DNS resolution** for all your devices, fully self-hosted.

---

## 📌 Features

* Full network ad-blocking
* Optional DNS-over-HTTPS / DNS-over-TLS
* Local recursive DNS (no third-party logging)
* Router-level DNS enforcement
* Fast local DNS caching
* Scales to 100+ devices
* Lightweight Proxmox VMs or LXCs

---

## 🏗 Architecture Diagram
![Architecture diagram](screenshots\diagram.png)
![Architecture diagram](screenshots\diagram1.png)
Figure: Network architecture — Devices → Router (DNS) → AdGuard Home → Unbound → Root DNS Servers.



## 🖥 Proxmox VM Setup

Use your **Proxmox helper script** to create the following VMs/LXCs:

| VM      | OS        | CPU | RAM   | IP            |
| ------- | --------- | --- | ----- | ------------- |
| Unbound | Debian 12 | 1   | 512MB | 192.168.1.254 |
| AdGuard | Debian 12 | 1   | 1GB   | 192.168.1.250 |

---

## ⚡ Installation Scripts

All installation steps are automated via scripts in the `scripts/` folder.

### 1️⃣ Unbound

```bash
bash scripts/install_unbound.sh
```

* Uses config: `configs/unbound.conf`
* Listens on port `5335`
* Screenshot placeholder: `screenshots/unbound_config.png`

### 2️⃣ AdGuard Home

```bash
bash scripts/install_adguard.sh
```

* Uses config: `configs/adguard_settings.yaml`
* Web UI: `http://192.168.1.250:3000`
* Screenshot placeholder: `screenshots/adguard_dashboard.png`

---

## 🔧 Configure AdGuard Upstream DNS

1. Open AdGuard Home dashboard:
   `Settings → DNS Settings → Upstream DNS Servers`
2. Add Unbound IP:

   ```
   192.168.1.254:5335
   ```
3. Enable:

   * Cache
   * DNSSEC
   * Parallel upstream queries → OFF
4. Ensure AdGuard listens on **Port 53** (`Settings → DNS`)
5. Restart service:

```bash
sudo systemctl restart AdGuardHome
```

---

## 🌐 Router Configuration

* Set **LAN DNS**:

```
Primary DNS: 192.168.1.250
Secondary DNS: (blank or same)
```

* Optional: enforce DNS by blocking external port 53 traffic.

---

## 🧪 Testing

### Test Unbound

```bash
nslookup google.com 192.168.1.254#5335
```

### Test AdGuard

```bash
nslookup github.com 192.168.1.250
```

### Test From Any Device

```bash
nslookup openai.com
```

*Should resolve through AdGuard → Unbound.*

---

## 🛠 Troubleshooting

* **Port 53 conflicts:**

  ```bash
  sudo lsof -i :53
  sudo systemctl stop systemd-resolved
  sudo systemctl disable systemd-resolved
  ```

* **No internet after DNS switch:**

  * Verify AdGuard upstream (`192.168.1.254:5335`)
  * Test connectivity:

    ```bash
    nc -vz 192.168.1.254 5335
    ```

* **Router ignores custom DNS:**

  * Some ISPs enforce DNS → enable DNS Hijacking protection or firewall rules.

---

## 🚀 Enhancements & Future Upgrades

* DNS-over-TLS / DNS-over-HTTPS outbound
* Pi-hole comparison setup
* Prometheus/Grafana monitoring
* Proxmox VM backups
* Failover AdGuard Home instance

---

## 📂 Repository Structure

```
├── README.md
├── diagram.png
├── scripts/
│   ├── install_unbound.sh
│   ├── install_adguard.sh
├── configs/
│   ├── unbound.conf
│   ├── adguard_settings.yaml
├── proxmox/
│   ├── vm_helper_script.md
│   ├── network_map.md
└── screenshots/
    ├── adguard_dashboard.png
    ├── unbound_config.png
    ├── router_dns_config.png
```

---

## 📜 License

MIT License – free for personal and commercial projects.

---

## 📧 Support

Open an **Issue** or start a **Discussion** on GitHub for help configuring, troubleshooting, or scaling this setup.

---
