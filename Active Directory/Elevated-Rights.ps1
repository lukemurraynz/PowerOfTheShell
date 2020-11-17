$RequiredDays = '1'
$GroupName = 'Domain Admins'
$Username = 'User1'
$DomainController = 'DOMAINCONTROLLER1'

Invoke-Command -ComputerName $DomainController -Scriptblock { Add-ADGroupMember -Identity "$GroupName" -Members "$Username" -MemberTimeToLive (New-TimeSpan -Days $Using:RequiredDays) }