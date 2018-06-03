<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:
    Purpose: Elevates Powershell as Admin if not already Admin and runs script.
#>

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {

    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    
        Exit
    
    }
    
}

Install-Module AzureRM