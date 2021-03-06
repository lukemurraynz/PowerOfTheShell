#requires -Version 3.0 -Modules Dism

<#
    .SYNOPSIS
    Disables SMB1

    .DESCRIPTION
    This script disables SMB1. If Windows 10 or greater it will use the PowerShell cmdlet to disable SMB1 with no restart, if the OS is
    less than Windows 10 - such as Windows 7 it will set the services to be disabled manually. Needs to be run as Administrator.

    .NOTES
    Version:        1.0
    Author:         Luke Murray
    Creation Date:  14/05/17
    Purpose/Change: 
    14/05/17 - Initial script creation
    09/06/18 - Script formatting changed and elevation function put in.


    .EXAMPLE
    ./Disable-SMB1.ps1
  
#>


#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Stop
$ErrorActionPreference = 'Stop'

#If script not ran as Administrator, request elevation of privilages and run script.

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) 
{
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) 
  {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    
    Exit
  }
}

#Gathers OS version
$OSVersion = (Get-WmiObject -Class win32_operatingsystem).version

#-----------------------------------------------------------[Execution]------------------------------------------------------------


try
{
  If($OSVersion -gt '10.*')
  {
    Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol -NoRestart -ErrorAction Stop
    Write-Verbose -Message 'Disabling... SMB1 Protocol. Restart to finish disabling SMB1.'
  }
  ElseIf($OSVersion -lt '10.*')
  {
    & "$env:windir\system32\sc.exe" config lanmanworkstation depend= bowser/mrxsmb20/nsi
    & "$env:windir\system32\sc.exe" config mrxsmb10 start= disabled
    Write-Verbose -Message 'Disabling... SMB1 Protocol. Restart to finish disabling SMB1.'
  }
}

catch [System.Runtime.InteropServices.COMException]
{
  [Management.Automation.ErrorRecord]$e = $_

  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
  }
  

  $info
}
