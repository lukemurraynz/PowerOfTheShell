#requires -Version 2.0 -Modules Az.Accounts, Az.Resources, CredentialManager


function New-AzureResourceGroup
{
  <#
      .SYNOPSIS
      Creates Azure Resource Group
      .DESCRIPTION
      Creates Azure Resource Group function, created as a test function for Universal Automation Desktop
      .EXAMPLE
      New-AzureResourceGroup
  #>
  param
  ([Parameter(Mandatory = $true, HelpMessage = 'Enter the name of the Resource Group you want to create', Position = 0)]
    [ValidateNotNullorEmpty()]
    [string] $Name,
    [Parameter(Position = 1)]
    [string]
    $Location = 'Australia East'

  )
     
  $tenantId = (Get-StoredCredential -Target 'MSDN SPN Demo').GetNetworkCredential().UserName 
  $pscredential = (Get-StoredCredential -Target 'MSDN SPN Demo Key')
  
  Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId
  
  New-AzResourceGroup -Name $Name -Location $Location -Force
}

New-AzureResourceGroup
