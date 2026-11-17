# Phase 7: Linux Server Hardening, Nginx Web Hosting & pfSense Port Forwarding (DMZ)

## Objective & Defense-in-Depth Architecture
Deploy and harden a public-facing **Nginx Web Server** inside the isolated **Demilitarized Zone (`DMZ-Lab` – `172.16.20.0/24`)** on **CentOS Stream 10**, exposing HTTP (`TCP 80`) externally via **pfSense WAN Port Forwarding (NAT)** while keeping the internal Active Directory corporate LAN (`172.16.10.0/24`) completely isolated.

## Traffic Flow & Security Layers

| Security Layer | Component | Configuration & Purpose |
| :--- | :--- | :--- |
| **Perimeter NAT & Firewall** | `pfSense-fw1` (`WAN: 192.168.92.141`) | Port-forwards external `TCP 80` to `172.16.20.50:80` while blocking DMZ-to-LAN lateral movement |
| **Host-Based Firewall** | `firewalld` (`centos-srv01`) | Enforces Defense-in-Depth by permitting only `http` (`80/tcp`) and `ssh` (`22/tcp`) on `ens160` |
| **SSH Daemon Hardening** | `sshd` (`/etc/ssh/sshd_config.d/99-hardening.conf`) | Disabled direct root login (`PermitRootLogin no`) to mitigate credential brute-force attacks |
| **Web Application Tier** | `nginx` (`172.16.20.50:80`) | Serves the **IvanCorp Enterprise Portal** from `/usr/share/nginx/html/index.html` |

## Key Configurations Implemented
1. **DMZ DNS & Web Server Provisioning:**
   * Configured DMZ DNS resolution (`172.16.20.1`, `8.8.8.8`) via `nmcli` so the isolated DMZ host resolves external repositories without querying internal AD DNS (`172.16.10.10`).
   * Installed and enabled `nginx` (`systemctl enable --now nginx`) with a custom **IvanCorp Enterprise Portal** landing page.
2. **Linux Host Hardening (`firewalld` & `sshd`):**
   * Restricted inbound host traffic to `http` and `ssh` via `firewall-cmd --permanent`.
   * Applied `/etc/ssh/sshd_config.d/99-hardening.conf` (`PermitRootLogin no`) and restarted `sshd`.
3. **pfSense WAN Port Forwarding (`Firewall > NAT > Port Forward`):**
   * Mapped `WAN address:80` (`192.168.92.141:80`) to `172.16.20.50:80` with an associated WAN pass filter rule.

## Verification Results
* **Local Loopback Test (`curl http://localhost`):** Returned HTTP 200 OK with custom portal HTML.
* **External WAN Access Test (`http://192.168.92.141`):** Successfully rendered the **IvanCorp Enterprise Portal** from an external client browser through pfSense NAT translation while maintaining 100% isolation from `172.16.10.0/24`.
