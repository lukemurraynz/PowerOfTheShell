#requires -Version 2.0

<#

    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.2
    Version History:
    0.1 - Created the script with basic Catch blocks
    0.2 - Added additional Error Checking and Event Log query

    Purpose: To Change the Remote Registry service to Automatic start-up and Start the DFS NameSpace service dependencies, then start the DFS namespace service.

#>

$ServiceName = 'DFS'
$ErrorActionPreference = 'Stop'

Try 
{
  Get-Service -Name RemoteRegistry | Set-Service -StartupType Automatic
}
Catch 
{
  Write-Verbose -Message 'There is an issue changing the Remote Registry Service to Automatic Startup Type' -Verbose
}
Try
{
  $ServiceDependency = Get-Service -Name $ServiceName -DependentServices
  $ServiceDependency |
  Set-Service -StartupType Automatic |
  Start-Service
  Write-Verbose -Message "$ServiceName dependencies have started. Will now try starting the $ServiceName service.." -Verbose
}
catch [Microsoft.PowerShell.Commands.ServiceCommandException]
{
  [Management.Automation.ErrorRecord]$e = $_

  $info = New-Object -TypeName PSObject -Property @{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Line      = $e.InvocationInfo.ScriptLineNumber
    Column    = $e.InvocationInfo.OffsetInLine
  }
  Write-Verbose -Message 'Opps! There was an error:' -Verbose
  $info
}
Catch 
{
  Write-Verbose -Message "There was an issue starting $ServiceName dependencies" -Verbose
}

try
{
  Try
  {
    Start-Service -Name $ServiceName
    Write-Verbose -Message "The $ServiceName service has started." -Verbose
  }
  Catch 
  {
    Get-WinEvent -LogName Microsoft-Windows-DFSN-Server/Operational | Select-Object -Last 10
  }
}

catch
{
  [Management.Automation.ErrorRecord]$e = $_

  $info = New-Object -TypeName PSObject -Property @{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Line      = $e.InvocationInfo.ScriptLineNumber
    Column    = $e.InvocationInfo.OffsetInLine
  }
  Write-Verbose -Message 'Opps! There was an error:' -Verbose
  $info
}