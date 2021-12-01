 #Log into M365
 Connect-IPPSSession -UserPrincipalName' it@name.co.nz'
#Start Compliance Search
 New-ComplianceSearch -Name Phish -ExchangeLocation All -ContentMatchQuery 'from:"badaddress@badcompany.com"'
 Start-ComplianceSearch -Identity Phish
 #Get Compliance Search
 Get-ComplianceSearch -Identity Phish | Format-list *
 #Delete Emails retrieved from Compliance Search
 New-ComplianceSearchAction -SearchName Phish -Purge -PurgeType HardDelete
 Get-ComplianceSearchAction