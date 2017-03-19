#requires -Version 2.0 -Modules ActiveDirectory

<#

    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: Simple script created to copy users from one Active Directory Group into another.


#>

$Source_Group = 'AD_Group_SourceGroup' 
$Destination_Group = 'AD_Group_DestinationGroup' 
 
$Target = Get-ADGroupMember -Identity $Source_Group -Recursive  
foreach ($Person in $Target) {  
    Add-ADGroupMember -Identity $Destination_Group -Members $Person.distinguishedname
}  