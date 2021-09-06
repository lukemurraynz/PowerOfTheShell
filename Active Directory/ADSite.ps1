<#

In a world where a server might exist on-premises today and in Azure tomorrow, locating where the server is actually located from one day to the next can be difficult.

This script finds all the Windows Servers in Active Directory, then executess an Invoke-Command to connect and pull the Active Directory Site that the server exists in.
It then sets the computer 

#>

#$Servers = Import-csv 'c:\temp\servers.csv'

$Servers = Get-ADComputer -Filter {OperatingSystem -like "*windows*server*"} -Properties * | Select-Object DNSHostName

ForEach ($server in $servers)
{
    Invoke-Command -ComputerName $server.Servers  -ScriptBlock {
        $data = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite().Name
        return $data
    }
    
    Set-ADComputer -Identity $env:computername | Set-ADComputer -Location $data
}