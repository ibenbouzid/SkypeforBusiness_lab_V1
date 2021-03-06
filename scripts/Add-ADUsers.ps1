#
# Add-NewADUsers.ps1
#
<# Custom Script for Windows #>
Param (		

	    [Parameter(Mandatory)]
        [string]$Password

       )
$Domain = Get-ADDomain
$DomainDNSName = $Domain.DNSRoot
$Computer = $env:computername + '.'+$Domain.DNSRoot
$OrgUnit = "SfBusers"
$Container = "ou="+$OrgUnit+","+$Domain.DistinguishedName

New-ADOrganizationalUnit -Name $OrgUnit -Path $Domain.DistinguishedName

Import-Csv .\New-ADUsers.csv | ForEach-Object {
    $userPrinc = $_.LogonUsername+"@"+$DomainDNSName
    New-ADUser -Name $_.Name `
    -SamAccountName $_.LogonUsername `
    -UserPrincipalName $userPrinc `
	-DisplayName $_.Name `
	-GivenName $_.FirstName `
    -SurName $_.LastName `
	-Description $_.Site `
	-Department $_.Dept `
    -Path $Container `
    -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force) `
	-Enabled $True `
	-PasswordNeverExpires $True `
    -PassThru
}