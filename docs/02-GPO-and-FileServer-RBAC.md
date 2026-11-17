# Phase 2: Organizational Units, Group Policy Hardening & File Server RBAC

## Objective & Business Justification
Structure Active Directory objects using a tiered **Organizational Unit (OU)** hierarchy, enforce workstation security baselines via **Group Policy Objects (GPO)**, and implement **Role-Based Access Control (RBAC)** on shared department folders.

## Organizational Unit (OU) Design (`IvanCorp`)
* **`IvanCorp`**
  * **`Admin_Accounts`** – Privileged administrative accounts separated from daily user accounts
  * **`Company_Devices`**
    * **`Tier1_Servers`** – Windows and Linux servers (`IFDNACION`, `CENTOS-SRV01`)
    * **`Tier2_Workstations`** – Employee desktop endpoints (`QC-HL-L001`)
  * **`HR` / `IT` / `Accounting`** – Department-specific user OUs for targeted GPO deployment
  * **`Security_Groups`** – Global Security Groups (`GRP_HR_Staff`, `GRP_IT_Staff`)

## Group Policy & Workstation Hardening
* **Domain Password & Lockout Policy:** Enforced minimum password complexity, length, and account lockout thresholds at the domain root.
* **Endpoint Security Restrictions:** Applied GPOs to standard user OUs to restrict Control Panel access, block unauthorized USB removable storage devices, and display a corporate legal login banner.

## File Server & RBAC Implementation
* **NTFS & Share Permissions:** Created department network shares (`HR_Share`, `IT_Share`) with **Authenticated Users** removed from inherited NTFS permissions, granting explicit **Modify** access exclusively to `GRP_HR_Staff` and `GRP_IT_Staff` (Principle of Least Privilege).
* **Automated Drive Mapping:** Configured **Group Policy Preferences (GPP)** with Item-Level Targeting to automatically map **`H:\`** (`HR_Share`) and **`I:\`** (`IT_Share`) upon domain user logon.
