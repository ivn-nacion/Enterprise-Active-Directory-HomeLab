# Phase 8: Centralized Cross-Platform Infrastructure Monitoring (Zabbix 7.0 LTS)

## Objective & Operational Justification
Deploy an enterprise **Zabbix 7.0 LTS** centralized monitoring server on **Ubuntu 24.04 LTS (`IFDNacion`)** backed by **MariaDB** and **Apache**, providing real-time visibility ("Single Pane of Glass") into CPU, memory, disk utilization, and service availability across Windows, RHEL-based DMZ, and Debian-based infrastructure.

## Monitored Infrastructure Matrix

| Hostname | Operating System | Network Zone & IP | Agent Version & Port | Assigned Template |
| :--- | :--- | :--- | :--- | :--- |
| **`Zabbix server` (`IFDNacion`)** | Ubuntu 24.04 LTS | Internal LAN (`172.16.10.51`) | Zabbix Agent (`127.0.0.1:10050`) | `Linux by Zabbix agent`, `Zabbix server health` |
| **`WIN-A9OADFLU63D`** | Windows Server 2025 (AD DC) | Internal LAN (`172.16.10.10`) | Zabbix Agent 2 (`172.16.10.10:10050`) | `Windows by Zabbix agent` |
| **`centos-srv01`** | CentOS Stream 10 (Nginx DMZ) | Perimeter DMZ (`172.16.20.50`) | Zabbix Agent (`172.16.20.50:10050`) | `Linux by Zabbix agent` |

## Key Configurations Implemented
1. **Zabbix 7.0 Server, Database & Web Frontend (`Ubuntu 24.04 LTS`):**
   * Installed `zabbix-server-mysql`, `zabbix-frontend-php`, `zabbix-apache-conf`, and `mariadb-server`.
   * Provisioned the UTF8MB4 `zabbix` database, imported initial schema tables, and configured `Asia/Manila (UTC+08:00)` timezone in the web dashboard (`http://172.16.10`).
2. **Cross-Platform Agent Deployment & Firewall Integration:**
   * **CentOS Stream 10 (DMZ):** Installed `zabbix7.0-agent` via EPEL, pointed `Server=` and `ServerActive=` to `172.16.10.51`, and opened `10050/tcp` in `firewalld` to permit secure LAN-to-DMZ metric polling.
   * **Windows Server 2025 (AD DC):** Deployed `zabbix_agent2-7.0.32` silently via `msiexec` (`SERVER=172.16.10.51`, `HOSTNAME=WIN-A9OADFLU63D`) with automated Windows Defender Firewall rule creation.

## Verification Results
* **Dashboard Availability:** Confirmed all **3 cross-platform hosts** (`Ubuntu`, `Windows Server 2025`, and `CentOS DMZ`) actively reporting telemetry metrics and health triggers inside the **IvanCorp NOC Monitoring** dashboard.
