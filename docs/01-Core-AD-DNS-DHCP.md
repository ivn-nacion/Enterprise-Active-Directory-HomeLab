# Phase 1: Core Network, Active Directory, DNS & DHCP Infrastructure

## Objective & Business Justification
Deploy an isolated enterprise network environment (`172.16.10.0/24`) protected by a **pfSense** perimeter firewall, with **Windows Server 2025** providing centralized identity management (**Active Directory Domain Services**), internal name resolution (**DNS**), and automated IP allocation (**DHCP**).

## Infrastructure Topology

| Hostname | Role / Operating System | Interface / Segment | IPv4 Address |
| :--- | :--- | :--- | :--- |
| **`pfsense-FW`** | Perimeter Firewall & NAT Gateway (pfSense CE) | WAN (`em0`) / LAN (`AD-Lab`) | WAN: DHCP / LAN: `172.16.10.1/24` |
| **`WIN-A9OADFLU63D`** | Primary Domain Controller, DNS, DHCP (`ivan.local`) | `AD-Lab` | `172.16.10.10/24` (Static) |
| **`QC-HL-L001`** | Domain-Joined Workstation (Windows 11 x64) | `AD-Lab` | `172.16.10.50/24` (DHCP) |

## Key Configurations Implemented
* **Isolated Virtual Networking:** Created a dedicated VMware LAN segment (`AD-Lab`) behind `pfsense-FW` to prevent DHCP conflicts with the host home network while providing outbound NAT internet access.
* **Active Directory Domain Services (AD DS):** Promoted Windows Server 2025 to Primary Domain Controller for the **`ivan.local`** forest/domain.
* **DNS & DHCP Services:** Configured forward lookup zones (`ivan.local`), verified SRV records (`_ldap._tcp.ivan.local`), and deployed a DHCP scope (`172.16.10.50` – `172.16.10.100`) pointing clients to `172.16.10.10` for internal DNS resolution.
* **Client Domain Join:** Joined **`QC-HL-L001`** (Windows 11) to `ivan.local` and verified domain user authentication.
