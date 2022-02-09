#Disable the "Add shortcut to OneDrive" 

$Sharepoint = https://COMPANY-admin.sharepoint.com
Connect-SPOService $Sharepoint
Set-SPOTenant -DisableAddShortCutsToOneDrive $True

To enable it again you can run:

Set-SPOTenant -DisableAddShortCutsToOneDrive $False
