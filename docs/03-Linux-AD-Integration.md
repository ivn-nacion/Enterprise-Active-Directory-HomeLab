# Phase 3: Cross-Platform Linux Active Directory Integration (Ubuntu & CentOS)

## Objective & Business Justification
Integrate heterogeneous Linux endpoints—**Ubuntu 24.04 LTS** (Debian-based) and **CentOS Stream 10** (RHEL-based)—into the **`ivan.local`** Active Directory domain using **SSSD**, **realmd**, and **Kerberos**. This eliminates local Linux password sprawl by enabling centralized domain authentication, automatic home directory provisioning, and Active Directory group-based `sudo` delegation.

## Linux Endpoints Integrated

| Hostname (FQDN) | Operating System | IPv4 Address | AD Computer OU |
| :--- | :--- | :--- | :--- |
| **`IFDNacion`** | Ubuntu 24.04 LTS | `172.16.10.51/24` | `IvanCorp > Company_Devices > Tier1_Servers` |
| **`centos-srv01.ivan.local`** | CentOS Stream 10 | `172.16.10.52/24` | `IvanCorp > Company_Devices > Tier1_Servers` |

## Key Configurations Implemented
* **DNS & Hostname Preparation:** Locked DNS resolution to `172.16.10.10` (`ivan.local`) via `nmcli` to avoid `.local` mDNS conflicts, and configured compliant FQDNs (`hostnamectl`) prior to domain join.
* **Domain Join & Kerberos Authentication:** Installed `realmd`, `sssd`, `adcli`, `oddjob-mkhomedir`, and Kerberos workstation tools, joining both hosts via `sudo realm join -U Administrator ivan.local`.
* **SSSD Optimization:** Configured `ad_gpo_access_control = permissive` and `ad_enable_gc = False` in `/etc/sssd/sssd.conf` for seamless compatibility with Windows Server 2025.
* **Active Directory Group-Based `sudo` Delegation:** Created `/etc/sudoers.d/ad-it-admins` (`chmod 440`) granting full `sudo` administrative rights exclusively to members of the Active Directory **`GRP_IT_Staff`** security group:
  ```text
  %grp_it_staff@ivan.local ALL=(ALL) ALL
  ```
* **GDM Login Screen Hardening:** Configured `/etc/dconf/profile/gdm` and `disable-user-list=true` on both desktop environments so users authenticate with their full domain UPN (`pbeltran@ivan.local`) while preventing local username enumeration.
