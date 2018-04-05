﻿#Secure DevOps Kit for Azure (AzSDK)
#https://github.com/azsdk/azsdk-docs#references

Install-Module AzSK -Scope CurrentUser -AllowClobber
Import-Module AzSK
$email = 'example@example.com, example1@example.com'
$phone = '00000000'
#Subid needs to be changed 
$subid = '9d2b9f7e-028e-45f7-b8ee-f447d9a6183f'

#Gets Azure Subscription Security Status and outputs to CSV
Get-AzSKSubscriptionSecurityStatus -SubscriptionId $subid

#Sets Azure Subscription Security, creates mandatory service accounts, 
Set-AzSKSubscriptionSecurity -SubscriptionId $subid -SecurityContactEmails $email -SecurityPhoneNumber $phone


#The subscription access control provisioning script ensures that certain central accounts and roles are setup in your subscription.
Set-AzSKSubscriptionRBAC -SubscriptionId $subid

#Creates Azure Alerts

Set-AzSKAlerts -SubscriptionId $subid -SecurityContactEmails $email -SecurityPhoneNumber $phone

#Sets up Azure Security Center

Set-AzSKAzureSecurityCenterPolicies -SubscriptionId $subid -SecurityContactEmails $email -SecurityPhoneNumber $phone

#Sets up ARM Azure POlicy to prevent some creation

Set-AzSKARMPolicies -SubscriptionId $subid

#Updates Azure Security Pacl

Update-AzSKSubscriptionSecurity -SubscriptionId $subid