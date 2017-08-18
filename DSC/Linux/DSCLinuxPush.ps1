#requires -Version 2.0 -Modules Posh-SSH

<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Purpose: DSC Push configuraton created on Windows machine, and pushed to Linux DSC.
#>


$credential = Get-Credential
$computer = 'servername.eastus.cloudapp.azure.com'
$sshsession = New-SSHSession -ComputerName "$computer" -Credential $credential
$mof = 'C:\Temp\DSC\localhost.mof'

#Upload DSC Config file using Set-SFTPFile
$SFTPSession = New-SFTPSession -ComputerName "$computer" -Credential $credential
Set-SFTPFile -SFTPSession $SFTPSession -LocalFile $mof -RemotePath /tmp -Overwrite

#Applies DSC Config File that was uploaded via previous command:
Invoke-SSHCommand -Command {sudo /opt/microsoft/dsc/Scripts/StartDscConfiguration.py -configurationmof /tmp/localhost.mof} -SSHSession $sshsession