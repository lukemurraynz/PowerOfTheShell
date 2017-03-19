#requires -Version 3.0
function Connect-Proxy
{
  <#
      .SYNOPSIS
      Basic Function to prompt for Proxy credentials to allow PowerShell to use a Proxy.
      .AUTHOR: Luke Murray (Luke.Geek.NZ)
      .VERSION: 0.1
      .EXAMPLE
      Connect-Proxy

  #>
  $webclient=New-Object System.Net.WebClient
  $creds=Get-Credential
  $webclient.Proxy.Credentials=$creds
}

Connect-Proxy

#Does an Update-Help to test Proxy works:
Update-Help -Force