$Users = Import-Csv -Path "C:\Scripts\NewHires.csv"
$Password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

foreach ($User in $Users) {
    $FullName = "$($User.FirstName) $($User.LastName)"
    $UPN = "$($User.Username)@ivan.local"

    New-ADUser -Name $FullName `
      -GivenName $User.FirstName `
      -Surname $User.LastName `
      -SamAccountName $User.Username `
      -UserPrincipalName $UPN `
      -Path $User.OU `
      -Department $User.Department `
      -AccountPassword $Password `
      -ChangePasswordAtLogon $true `
      -Enabled $true

    Add-ADGroupMember -Identity $User.SecurityGroup -Members $User.Username
    Write-Host "Successfully created and assigned: $FullName ($UPN)" -ForegroundColor Green
}
