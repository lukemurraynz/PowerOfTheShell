$minLength = 5 ## characters
$maxLength = 64 ## characters
$length = Get-Random -Minimum $minLength -Maximum $maxLength
$nonAlphaChars = 5
add-type -AssemblyName System.Web
$password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
$secPw = ConvertTo-SecureString -String $password -AsPlainText -Force


$Username = 'LastNameFirstName'
New-LocalUser "$Username" -Password $secPw -FullName "FirstName Lastname" -Description "Vendor - Local Administrator Account."
Add-LocalGroupMember -Group 'Administrators' -Member "$Username" 