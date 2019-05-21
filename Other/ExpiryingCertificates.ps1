
Invoke-Command -ComputerName (Get-ADComputer -LDAPFilter '(&(objectCategory=computer)(operatingSystem=Windows Server*)(!serviceprincipalname=*MSClusterVirtualServer*)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))' -Property name | Sort-Object -Property Name).Name -Command {
  Get-ChildItem -Path cert:LocalMachine\My -Recurse |
  Where-Object -FilterScript {
    $_.NotAfter -gt (Get-Date)
  } |
  Select-Object -Property Subject, FriendlyName, Thumbprint, @{
    Name       = 'Expires in (Days)'
    Expression = {
      ($_.NotAfter).subtract([DateTime]::Now).days
    }
  } |
  Where-Object -Property 'Expires in (Days)' -LT -Value 120
} | Export-Csv -Path c:\temp\ExpiringCertificates.csv
