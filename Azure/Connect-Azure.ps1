#requires -Version 3.0 -Modules AzureRM
function Connect-Azure
{
  <#
      .SYNOPSIS
      Connect-Azure Function to login to Azure - using Resource Groups.
      .DESCRIPTION
      Prompts for Azure user credentials, prompts to select Azure Subscription and passes through to select an Azure subscrption.
      .EXAMPLE
      Connect-Azure
      .AUTHOR: Luke Murray (Luke.Geek.NZ)
      .VERSION: 0.1
  #>
  Import-Module -Name AzureRM -Verbose -Force
  
  #Authenticate to Azure with Azure RM credentials
  
  Add-AzureRmAccount
  
  #Select Azure Subscription
  $subscriptionName = (Get-AzureRmSubscription).SubscriptionName | Out-GridView -Title 'Select Azure Subscription' -PassThru
  Set-AzureRmContext -SubscriptionName $subscriptionName
}

Connect-Azure