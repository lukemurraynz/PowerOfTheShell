Import-Module SecretServer
Set-SecretServerConfig -Uri https://secretserver.domain.co.nz/secretserver/winauthwebservices/SSWinAuthWebService.asmx
New-SSConnection #Uses Uri we just set by default

$Credential = (Get-Secret -SearchTerm 'username' -IncludeRestricted -as Credential ).Credential
$Credential
