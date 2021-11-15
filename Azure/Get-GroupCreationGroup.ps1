#Connects to Microsoft Azure
Connect-AzureAD
#Displays the values, including the GroupCreationAllowedGroupId:
(Get-AzureADDirectorySetting).values

# Gets Azure AD group Info
$id = ''
Get-AzureADGroup -ObjectId $id| fl