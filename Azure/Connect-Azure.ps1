#requires -Modules Az.Accounts
#requires -version 3.0
<#
    .SYNOPSIS
    Connect-Azure

    .DESCRIPTION
    Loads the Azure Resource Manager modules, then connects to Azure and opens a Window allowing you to select what subscription.

    .NOTES
    Version:        1.1
    Author:         Luke Murray (Luke.Geek.NZ)
    Creation Date:  20/03/17
    Purpose/Change: 
    20/03/17 - Intiial script development
    09/06/2018 - script format cleanup
    25/03/2021 - Updated script (finally) to Az module. Updated to 1.1.

    .EXAMPLE
    Connect-Azure
  
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'Stop'

#Import Modules & Snap-ins
Import-Module Az.Accounts

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Connect-Azure
{
  #Prompts for Azure credentials
  Connect-AzAccount
  
  #Prompts Window allowing you to select which  Azure Subscription to connect to
  $subscriptionName = (Get-AzSubscription) | Out-GridView -Title 'Select Azure Subscription' -PassThru
  Set-AzContext -SubscriptionName $subscriptionName
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Connect-Azure