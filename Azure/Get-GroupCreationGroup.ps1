#Connects to Microsoft Azure
Connect-AzureAD
#Displays the values, including the GroupCreationAllowedGroupId:
(Get-AzureADDirectorySetting).values

# Gets Azure AD group Info
$a = (Get-AzureADDirectorySetting).Values
$groupCreationAllowedGroupId = $a| Where-Object {$_.Name -eq "GroupCreationAllowedGroupId"}
$id = $groupCreationAllowedGroupId.Value

Get-AzureADGroup -ObjectId $id| fl