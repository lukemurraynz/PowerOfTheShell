# Import System.Web assembly
Add-Type -AssemblyName System.Web
# Generate random password
$password = [System.Web.Security.Membership]::GeneratePassword(128,2)
