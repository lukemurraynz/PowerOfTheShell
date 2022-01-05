#Uses the Secret Server Module, to connect to a locally installed Secret Server instance and pulls the credential to be used in scripts.
# https://www.powershellgallery.com/packages/SecretServer/1.0

Import-Module SecretServer
Set-SecretServerConfig -Uri https://secretserver.domain.co.nz/secretserver/winauthwebservices/SSWinAuthWebService.asmx
New-SSConnection #Uses Uri we just set by default
$secretname = 'MySecret'

$Credential = (Get-Secret -SearchTerm $secretname -IncludeRestricted -as Credential ).Credential
$Credential
