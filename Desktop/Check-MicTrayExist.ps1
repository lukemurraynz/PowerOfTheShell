$a = Get-Content -Path C:\temp\HPKeyLogger.txt
$b = Get-Credential

#requires -Version 2.0
<#

    Author: Luke Murray (luke.geek.nz)
    Version: 0.1

    Purpose: Determines if the HP 'Keylogger' exists and if so deletes the files.

    https://www.bleepingcomputer.com/news/security/keylogger-found-in-audio-driver-of-hp-laptops/

    With the Boolean logic can be easily modified to a Configuration Manager Configuration Baseline.

#>

Invoke-Command -ComputerName $a -Credential $b -ScriptBlock {

if ( (Test-Path -Path $env:windir\System32\MicTray64.exe) -or (Test-Path -Path $env:windir\System32\MicTray.exe) ) 
{
  Remove-Item -Path $env:windir\System32\MicTray64.exe -ErrorAction SilentlyContinue
  Remove-Item -Path $env:windir\System32\MicTray.exe -ErrorAction SilentlyContinue
  Remove-Item -Path $env:PUBLIC\MicTray.log -ErrorAction SilentlyContinue
  Write-Verbose -Message True -Verbose
}
else
{
  Write-Verbose -Message False -Verbose
}
}
