#requires -Modules ActiveDirectory, ConfigurationManager
#requires -Version 2.0

<#

    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: To create user collections in Configuration Manager that are based on Department. 

    This requires the Department field to be added to Active Directory User discovery in Configuration Manager.

#>

#Imports the Configuration Manager Module. If the Configuration Manager console is not installed in the default path, this will need to be changed. You will also need to launch PowerShell from within Configuration Manager first.
Import-Module -Name "${env:ProgramFiles(x86)}\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" 
#Specifies the site code - this will need to be modified, depending on the site code you are using in your environment.
$sitecode = 'WNT:'
#Sets the location of the script to UserCollection and then creates a Departments folder. You can rename "Departments" to suit your environment.

Set-Location $sitecode
New-Item -Name 'UserCollection\Departments'

# Helper function for creating a collection refresh schedule
Function New-RandomSchedule()
{
  "01/01/2000 $((Get-Random -Min 0 -Max 23).ToString('00')):$((Get-Random -Min 0 -Max 59).ToString('00')):00"
}

$Schedule = New-CMSchedule -Start (New-RandomSchedule) -RecurInterval Days -RecurCount 7   

#Sets the Active Directory parameters, this needs to be modified for your environment, your domain root or Domain Controller, the OU of the user accounts you want to query to obtain the departments.
$ADUserParams=@{ 
  'Server' = 'DC1.DOMAIN.COM' 
  'Searchbase' = 'OU=Users,DC=DOMAINNAME,DC=COM' 
  'Searchscope'= 'Subtree' 
  'Filter' = 'Enabled -eq $True'
  'Properties' = 'Department' 
} 

  $departments = Get-Aduser @ADUserParams | select-object -ExpandProperty Department -Unique
  foreach ($department in $departments)
 {
  $UserCollection = New-CMUserCollection -Name $department -Comment "This is a user collection, based off the Department name of $department which is from the Active Directory Department field." -LimitingCollectionName 'All Users' -RefreshType Periodic -RefreshSchedule $Schedule
  Add-CMUserCollectionQueryMembershipRule -CollectionName $department -RuleName $department -QueryExpression ("select SMS_R_USER.ResourceID,SMS_R_USER.ResourceType,SMS_R_USER.Name,SMS_R_USER.UniqueUserName,SMS_R_USER.WindowsNTDomain from SMS_R_User where SMS_R_User.department = `"$department`" order by SMS_R_User.Name")
  Move-CMObject -InputObject $UserCollection -FolderPath "$sitecode\UserCollection\Departments"
 }