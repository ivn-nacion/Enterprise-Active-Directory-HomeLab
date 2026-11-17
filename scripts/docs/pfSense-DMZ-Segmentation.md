# Network Segmentation & Stateful DMZ Firewalling (pfSense)

## Objective & Security Justification
Architect an isolated **Demilitarized Zone (DMZ)** (`172.16.20.0/24`) alongside the internal corporate LAN (`172.16.10.0/24`) on **pfSense CE**, preventing compromised perimeter servers from pivoting to the internal Active Directory Domain Controller or employee endpoints.

## Interface & Network Design

| pfSense Interface | VMware LAN Segment | Subnet & Gateway | DHCP Pool | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`LAN` (`em1`)** | `AD-Lab` | `172.16.10.1/24` | Managed by Windows Server 2025 | Trusted Internal Corporate Network |
| **`OPT1` (`DMZ` / `em2`)** | `DMZ-Lab` | `172.16.20.1/24` | `172.16.20.50` – `172.16.20.100` | Isolated Perimeter Zone (`centos-srv01`) |

## Stateful Firewall Rules (`Firewall > Rules > DMZ`)
1. **Block Lateral Movement (Top Priority):** `Block` | Source: `DMZ subnets` | Destination: `LAN subnets` | Protocol: `Any`
2. **Allow Outbound Updates:** `Pass` | Source: `DMZ subnets` | Destination: `Any` | Protocol: `Any`

## Verification Results
* **DMZ → Internet (`8.8.8.8`):** `0% packet loss` (Allowed for OS security updates)
* **DMZ → Internal LAN (`172.16.10.10`):** `100% packet loss` (Lateral movement blocked)
* **Internal LAN → DMZ (`172.16.20.50`):** `0% packet loss` (One-way stateful admin access allowed)
