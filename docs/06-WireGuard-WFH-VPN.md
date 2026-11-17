# Phase 6: Remote Access VPN for Work-From-Home (WFH) Connectivity (WireGuard)

## Objective & Security Justification
Configure a high-speed, cryptographically secured **WireGuard Remote Access VPN** on **pfSense CE** (`172.16.50.0/24`) to enable remote endpoints (`QC-HL-L001`) to securely access internal Active Directory resources and SMB file shares (`172.16.10.0/24`) without exposing internal ports directly to the public internet.

* **Why WireGuard?** Unlike legacy VPNs that rely solely on static passwords susceptible to brute-force attacks, WireGuard authenticates endpoints using asymmetric **Public/Private cryptographic key pairs** (`UDP 51820`) with silent packet dropping for unauthorized peers, while preserving full Active Directory NTFS/RBAC enforcement over the encrypted tunnel.

## Network & Tunnel Architecture

| Component | Interface / Subnet | IPv4 Address | Role / Allowed Traffic |
| :--- | :--- | :--- | :--- |
| **`pfSense-fw1` (VPN Server)** | `tun_wg0` (`WFH_Remote_Access`) | `172.16.50.1/24` (WAN: `192.168.92.141:51820`) | Terminates encrypted UDP WireGuard tunnels and routes traffic to `LAN subnets` |
| **`QC-HL-L001` (WFH Client)** | `IvanCorp-WFH` (External `NAT`) | `172.16.50.10/32` (DNS: `172.16.10.10`) | Remote employee workstation accessing `172.16.10.0/24` resources |

## Key Configurations Implemented
1. **pfSense Tunnel & Peer Provisioning (`VPN > WireGuard`):**
   * Created tunnel **`tun_wg0`** listening on **`UDP 51820`** with interface subnet **`172.16.50.1/24`**.
   * Registered **`QC-HL-L001`** as an authorized peer using its public key and restricted tunnel IP **`172.16.50.10/32`**.
2. **Firewall Policy Enforcement (`Firewall > Rules`):**
   * **WAN Interface:** Permitted inbound **`UDP 51820`** to `WAN address` for encrypted tunnel handshakes.
   * **WireGuard Interface:** Permitted authenticated VPN peers (`172.16.50.0/24`) to reach internal **`LAN subnets`** (`172.16.10.0/24`).
3. **Client Split-Tunnel Configuration (`Windows 11`):**
   * Configured `AllowedIPs = 172.16.10.0/24, 172.16.50.0/24` and internal DNS `172.16.10.10` so corporate traffic routes securely over the VPN while regular internet traffic uses the employee's local connection.

## Verification Results
* **Tunnel Connectivity (`ping 172.16.10.10`):** `0% packet loss` (`<1ms–1ms` latency) from external network (`NAT`).
* **SMB File Share & RBAC Verification (`net view \\172.16.10.10`):** Confirmed access to **`\\172.16.10.10\CompanyShare`** over the encrypted WireGuard tunnel while preserving Active Directory group permissions.
