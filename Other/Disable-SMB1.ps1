<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:
    Purpose: Disables SMB1.
#>

$OSVersion = (Get-WmiObject -Class win32_operatingsystem).version

try
{
  If($OSVersion -gt '10.*')
  {
    Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol -NoRestart -ErrorAction Stop
    Write-Verbose -Message 'Disabling... SMB1 Protocol. Restart finish disabling SMB1.'
  }
  ElseIf($OSVersion -lt '10.*')
  {
    & "$env:windir\system32\sc.exe" config lanmanworkstation depend= bowser/mrxsmb20/nsi
    & "$env:windir\system32\sc.exe" config mrxsmb10 start= disabled
    Write-Verbose -Message 'Disabling... SMB1 Protocol. Restart finish disabling SMB1.'
  }
}

catch [System.Runtime.InteropServices.COMException]
{
  [Management.Automation.ErrorRecord]$e = $_

  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
  }
  

  $info
}
