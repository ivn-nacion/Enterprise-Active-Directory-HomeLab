# Phase 4: PowerShell Active Directory Identity Automation

## Objective & Business Justification
Automate single and bulk Active Directory user provisioning on **Windows Server 2025** using PowerShell and CSV data ingestion. Automating onboarding eliminates manual GUI errors, ensures consistent Organizational Unit placement, and enforces immediate Role-Based Access Control (RBAC).

## Automation Workflows Implemented

### 1. Single-User Onboarding (`New-ADUser`)
Used for individual ad-hoc hires to create an account, place it in the target department OU, enforce a temporary password reset on first login (`-ChangePasswordAtLogon $true`), and bind it to its department Global Security Group (`Add-ADGroupMember`).

### 2. Bulk User Onboarding via CSV Ingestion ([`scripts/New-BulkADUsers.ps1`](../scripts/New-BulkADUsers.ps1))
Used during batch hiring events by ingesting a structured HR spreadsheet ([`scripts/NewHires.csv`](../scripts/NewHires.csv)) with `Import-Csv` and iterating through each record via a `foreach` loop:
* Dynamically constructs full names and User Principal Names (`username@ivan.local`).
* Provisions accounts directly into their respective department OUs (`HR` and `IT`).
* Assigns users to **`GRP_HR_Staff`** or **`GRP_IT_Staff`**, automatically granting mapped network drives (`H:\` / `I:\`) and delegated Linux `sudo` privileges upon first login.
