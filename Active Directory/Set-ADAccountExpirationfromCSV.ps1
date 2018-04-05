#requires -Version 2.0 -Modules ActiveDirectory

<#

Author: Luke Murray
Version: 1.0
Version History:

1.0 - Script creation

Purpose:

To import CSV of users (with Firstname, Lastname values) and change the expiration date for all the accounts in the CSV.
Remove '-whatif' to actually make change and change the -DateTime value to match how far ahead you want the AD account to be expired.

#>

$users = Import-Csv -Path C:\temp\users.csv           
           
foreach ($user in $users) {           
    $fname = $user.Firstname
    $lname = $user.Lastname
 
    Get-ADUser -Filter {
        GivenName -eq $fname  -and Surname -eq $lname
    } -Properties * |  Set-ADAccountExpiration -DateTime '31/03/2019' -Whatif
}
