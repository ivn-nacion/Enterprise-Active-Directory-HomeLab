# 10 - Active Directory Metadata Cleanup, Cross-VLAN DNS & PowerShell User Lifecycle

## Overview
Validated Active Directory Domain Services (AD DS) health on **Windows Server 2025 (`WIN-A9OADFLU63D.ivan.local`)** following migration to **VLAN 20 (`10.100.20.100`)**, performed metadata cleanup of an orphaned Read-Only Domain Controller (RODC), resolved cross-VLAN client authentication, and executed full user lifecycle management via **PowerShell**.

---

## 1. Active Directory Health Audit & Metadata Cleanup
* **Orphaned RODC Removal:** Identified stale replication and connectivity failures caused by an offline Read-Only Domain Controller (`WIN-TD3U2HT4N0H` under `Cebu-Branch`). Removed its `NTDS Settings` and parent server object cleanly via **Active Directory Sites and Services**.
* **DC DNS & Service Remediation:** Reconfigured the Domain Controller's NIC Primary DNS to loopback (`127.0.0.1`) with pfSense (`10.100.20.1`) set as the DNS Forwarder, enabled the **Intersite Messaging (`IsmServ`)** service, and re-registered `_msdcs.ivan.local` SRV records (`ipconfig /registerdns` & `Restart-Service Netlogon`).
* **Diagnostic Validation:** Confirmed clean domain controller health via `dcdiag /test:connectivity /test:services`.

---

## 2. Cross-VLAN Client Authentication (VLAN 30 to VLAN 20)
* Migrated the Windows 11 Enterprise client (`QC-HL-L001`) to a `vmxnet3` virtual adapter tagged with **VLAN ID 30** (`10.100.30.100`).
* Configured pfSense VLAN 30 DHCP options to hand out the Domain Controller (`10.100.20.100`) as the primary DNS server and added firewall rules permitting domain authentication traffic across subnets.
* Verified Domain Controller discovery from VLAN 30 using `nltest /dsgetdc:ivan.local`.

---

## 3. PowerShell Active Directory User Lifecycle Automation
Built and structured enterprise Organizational Units (`Corp_Users\IT_Admin`, `Corp_Workstations`, `Corp_Servers`, `Disabled_Accounts`) and executed core administration tasks via PowerShell:

```powershell
# 1. Inspect User Lockout & Password Status
Get-ADUser -Identity jdcruz -Properties LockedOut, PasswordLastSet, LastLogonDate |
    Select-Object Name, LockedOut, PasswordLastSet, LastLogonDate

# 2. Unlock User Account
Unlock-ADAccount -Identity jdcruz

# 3. Administrative Password Reset
$TempPass = ConvertTo-SecureString "Welcome@2026" -AsPlainText -Force
Set-ADAccountPassword -Identity jdcruz -Reset -NewPassword $TempPass
Set-ADUser -Identity jdcruz -ChangePasswordAtLogon $false -Enabled $true

# 4. New Hire Provisioning
New-ADUser -Name "Maria Santos" -GivenName "Maria" -Surname "Santos" `
    -SamAccountName "msantos" -UserPrincipalName "msantos@ivan.local" `
    -Path "OU=IT_Admin,OU=Corp_Users,DC=ivan,DC=local" `
    -AccountPassword \$TempPass -Enabled true -ChangePasswordAtLogon true

# 5. Employee Offboarding (Disable & Migrate to Disabled_Accounts OU)
Disable-ADAccount -Identity jdcruz
Get-ADUser -Identity jdcruz | Move-ADObject -TargetPath "OU=Disabled_Accounts,DC=ivan,DC=local"
```

---

## Key Operational Takeaways
1. **Domain Controller DNS Architecture:** A Domain Controller's network interface must always point to `127.0.0.1` (or its own static IP) for local `_msdcs` SRV resolution, using the perimeter firewall (`10.100.20.1`) strictly as a DNS Forwarder.
2. **Kerberos Session Persistence:** Disabling an AD user account prevents new logons immediately, but existing active sessions remain open until the user locks/logs off or an administrator forces a remote session logoff.
