#requires -Modules AzureRM.Profile
#requires -version 3.0
<#
    .SYNOPSIS
    Connect-Azure

    .DESCRIPTION
    Loads the Azure Resource Manager modules, then connects to Azure and opens a Window allowing you to select what subscription.


    .NOTES
    Version:        1.0
    Author:         Luke Murray (Luke.Geek.NZ)
    Creation Date:  20/03/17
    Purpose/Change: 
    20/03/17 - Intiial script development
    09/06/2018 - script format cleanup

    .EXAMPLE
    Connect-Azure
  
#>


#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'Stop'

#Import Modules & Snap-ins
Import-Module -Name AzureRM -Verbose -Force


#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Connect-Azure
{
  #Prompts for Azure credentials
  Connect-AzureRmAccount
  
  #Prompts Window allowing you to select which  Azure Subscription to connect to
  $subscriptionName = (Get-AzureRmSubscription) | Out-GridView -Title 'Select Azure Subscription' -PassThru
  Set-AzureRmContext -SubscriptionName $subscriptionName
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

Connect-Azure