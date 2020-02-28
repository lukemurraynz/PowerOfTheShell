#requires -Version 2.0 -Modules Az.Accounts, Az.Resources, CredentialManager
function New-AzureResourceGroup
{
  <#
      .SYNOPSIS
      Creates Azure Resource Group
      .DESCRIPTION
      Creates Azure Resource Group
      .EXAMPLE
      New-AzureResourceGroup
  #>
  param
  (
    [Parameter(Position=0)]
    [string]
    $Name = 'RG01',
    [Parameter(Position=1)]
    [string]
    $Location = 'Australia East'
  )
  
  $tenantId = (Get-StoredCredential -Target 'MSDN SPN Demo').GetNetworkCredential().UserName 
  $pscredential = (Get-StoredCredential -Target 'MSDN SPN Demo Key')
  
  Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId
  
  New-AzResourceGroup -Name $Name -Location $Location
}

New-AzureResourceGroup -Name $Name -Location $Location
