# Enterprise Active Directory & Cross-Platform Infrastructure Home Lab

End-to-end enterprise IT infrastructure home lab built on **VMware Workstation**, simulating a multi-OS corporate environment with centralized identity management, network segmentation, remote-access VPN, role-based access control (RBAC), and cross-platform Linux integration.

---

## 🏗️ Lab Architecture & IP Addressing Plan

| Hostname / VM | Role / Operating System | Network Segment | IPv4 Configuration |
| :--- | :--- | :--- | :--- |
| **`pfSense-fw1`** | Perimeter Firewall, DMZ Router & WireGuard VPN (`pfSense CE`) | WAN / `AD-Lab` / `DMZ-Lab` / `WireGuard` | LAN: `172.16.10.1/24` \| DMZ: `172.16.20.1/24` \| VPN: `172.16.50.1/24` |
| **`WIN-A9OADFLU63D`** | Primary Domain Controller, DNS, DHCP, File Server (`Windows Server 2025`) | `AD-Lab` (`172.16.10.0/24`) | `172.16.10.10/24` (Static) |
| **`QC-HL-L001`** | Enterprise Client & WFH VPN Workstation (`Windows 11 x64`) | `AD-Lab` / External `NAT` + VPN | LAN: `172.16.10.50/24` \| VPN: `172.16.50.10/32` |
| **`IFDNacion`** | Debian-Based Linux Endpoint (`Ubuntu 24.04 LTS`) | `AD-Lab` (`172.16.10.0/24`) | `172.16.10.51/24` (DHCP) |
| **`centos-srv01`** | RHEL-Based Server & DMZ Endpoint (`CentOS Stream 10`) | `AD-Lab` / `DMZ-Lab` (`172.16.20.0/24`) | LAN: `172.16.10.52/24` \| DMZ: `172.16.20.50/24` |

---

## 📂 Lab Phases & Technical Documentation

* **[Phase 1: Core Network, Active Directory, DNS & DHCP Infrastructure](docs/01-Core-AD-DNS-DHCP.md)** – Deployed isolated `172.16.10.0/24` corporate network behind pfSense with Windows Server 2025 managing `ivan.local` AD DS, DNS, and DHCP.
* **[Phase 2: Organizational Units, Group Policy Hardening & File Server RBAC](docs/02-GPO-and-FileServer-RBAC.md)** – Built tiered `IvanCorp` OU hierarchy, enforced workstation security GPOs, configured NTFS RBAC permissions, and automated network drive mappings (`H:\` & `I:\`).
* **[Phase 3: Cross-Platform Linux Active Directory Integration](docs/03-Linux-AD-Integration.md)** – Joined Ubuntu 24.04 LTS and CentOS Stream 10 to `ivan.local` via `realmd`, `sssd`, and Kerberos with AD group-based `sudo` delegation and GDM login hardening.
* **[Phase 4: PowerShell Active Directory Identity Automation](docs/04-PowerShell-AD-Automation.md)** – Automated single and bulk CSV user provisioning (`scripts/New-BulkADUsers.ps1` & `scripts/NewHires.csv`) with automatic OU placement and security group assignment.
* **[Phase 5: Network Segmentation & Stateful DMZ Firewalling](docs/05-pfSense-DMZ-Segmentation.md)** – Architected an isolated `172.16.20.0/24` DMZ interface on pfSense with stateful firewall rules blocking lateral movement to the internal LAN.
* **[Phase 6: Remote Access VPN for Work-From-Home Connectivity](docs/06-WireGuard-WFH-VPN.md)** – Deployed a `172.16.50.0/24` WireGuard VPN tunnel on pfSense with public-key peer authentication and split-tunnel routing for secure remote SMB file share access.
