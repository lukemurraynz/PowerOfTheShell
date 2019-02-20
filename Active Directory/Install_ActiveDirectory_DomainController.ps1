$domain = 'luke.geek.nz'
$cred = Get-Credential
Set-TimeZone -Id "New Zealand Standard Time"

#Installs AD Roles & Features
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
#Run prerequisite check 
Import-Module ADDSDeployment
Test-ADDSDomainControllerInstallation -InstallDns -Credential $cred -DomainName $domain
#If checks above look ok then run the following to install Active Directory and add to the domain
Install-ADDSDomainController -InstallDns -DomainName $domain –Confirm:$False

#Verify AD services are running
Get-Service adws, kdc, netlogon, dns
#Verify AD is replicating
Get-ADReplicationPartnerMetadata -Target * -Partition * | Select-Object Server, Partition, Partner, ConsecutiveReplicationFailures, LastReplicationSuccess, LastRepicationResult

#Review Logs after AD promotion for errors:
Get-Eventlog "Directory Service" | select entrytype, source, eventid, message
Get-Eventlog "Active Directory Web Services" | select entrytype, source, eventid, message

#Install DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Restart-service dhcpserver