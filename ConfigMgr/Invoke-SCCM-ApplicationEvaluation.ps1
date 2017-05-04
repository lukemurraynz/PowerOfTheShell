#requires -Version 1.0
<#

    Author: Luke Murray
    Version: 0.1
    Version History: 0.1

    Purpose: Intended to be used to run SCCM Application policy cycles. This requires local Admin rights on the computer and has been made to be compiled into an executable that a Service Desk could use.

#>

$Color = 'Green'
Start-Transcript -Path $env:TEMP\SCCMAppEval.log

function Invoke-AppDeployEvalCycle {  
  <#  
      .SYNOPSIS  
      Initiates a Application Deployment Evaluation Cycle 
        
      .DESCRIPTION  
      This will initiate a Application Deployment Evaluation Cycle.
        
      .EXAMPLE  
      PS C:\> Invoke-AppDeployEvalCycle 
        
      .NOTES  
      Additional information about the function.  
  #>  
        
  [CmdletBinding()]  
  param ()  
        
  $ComputerName = $env:COMPUTERNAME  
  $SMSCli = [wmiclass] "\\$ComputerName\root\ccm:SMS_Client"  
  $SMSCli.TriggerSchedule('{00000000-0000-0000-0000-000000000121}') #| Out-Null  
}  

function Invoke-DiscoveryDataCycle {  
  <#  
      .SYNOPSIS  
      Initiate a Discovery Data Collection Cycle
        
      .DESCRIPTION  
      This will initiate a Discovery Data Collection Cycle.
        
      .EXAMPLE  
      PS C:\> Invoke-DiscoveryDataCycle 
        
      .NOTES  
      Additional information about the function.  
  #>  
        
  [CmdletBinding()]  
  param ()  
        
  $ComputerName = $env:COMPUTERNAME  
  $SMSCli = [wmiclass] "\\$ComputerName\root\ccm:SMS_Client"  
  $SMSCli.TriggerSchedule('{00000000-0000-0000-0000-000000000003}') #| Out-Null  
}  

function Invoke-MachinePolicyCycle {  
  <#  
      .SYNOPSIS  
      Initiate a Machine Policy Retrieval Cycle
        
      .DESCRIPTION  
      This will initiate a Machine Policy Retrieval Cycle.
        
      .EXAMPLE  
      PS C:\> Invoke-MachinePolicyCycle 
        
      .NOTES  
      Additional information about the function.  
  #>  
        
  [CmdletBinding()]  
  param ()  
        
  $ComputerName = $env:COMPUTERNAME  
  $SMSCli = [wmiclass] "\\$ComputerName\root\ccm:SMS_Client"  
  $SMSCli.TriggerSchedule('{00000000-0000-0000-0000-000000000021}')# | Out-Null  
}  
 

Write-Host -ForegroundColor $Color 'Application Deployment Evaluation Cycle..'
Invoke-AppDeployEvalCycle
Write-Host -ForegroundColor $Color 'Discovery Data Collection Cycle..'
Invoke-DiscoveryDataCycle
Write-Host -ForegroundColor $Color 'Machine Policy Retrieval Cycle..'
Invoke-MachinePolicyCycle
Write-Host -ForegroundColor $Color Log has been outputted to: "$env:TEMP"
Stop-Transcript
