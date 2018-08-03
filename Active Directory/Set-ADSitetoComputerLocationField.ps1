#requires -Version 2.0 -Modules ActiveDirectory

<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:
    Purpose: Script to login to a list of servers using PowerShell and grab the AD Site the server is applied to and update the servers AD Object Location field with AD site.
#>

#$servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"}  | select-object -expandproperty name
$servers = Get-Content 'C:\Temp\servers.txt'
$cred = Get-Credential

ForEach ($server in $servers) {

    $ADsite = Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock {
        function Get-ComputerSite {
            $site = nltest /dsgetsite 2>$null
            if ($LASTEXITCODE -eq 0) { $site[0] }
        }
        Get-ComputerSite
    }
    Set-ADComputer -Identity $server  -Location $ADsite -WhatIf

}
