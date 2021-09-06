#requires -Version 2.0
$VerbosePreference = 'continue'
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Confirm:$false -Force

Write-Host -NoNewline -Object 'Press Any key when you are ready - Make sure you run this as Administrator...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

#Creates folder for PowerShell Script Logs + Event Viewer Logs
$Computer = $env:COMPUTERNAME  
$date = Get-Date -Format dd-MM-yyyy
$path = "C:\temp\$Computer\"

New-Item -Force -ItemType directory -Path $env:HOMEDRIVE\temp

If(!(Test-Path $path))
{
  New-Item -ItemType Directory -Force -Path $path
}

#Enables Windows Networking Event Viewer Logs
Write-Host -Object 'Starting PowerShell Logging...'  -ForegroundColor Green
Start-Transcript -Path "$path\PSTransScript _ $date _.log"
Write-Host -Object 'Enabling Windows Networking VPN Operational Logs'  -ForegroundColor Green
$wineventlog = Get-WinEvent -ListLog 'Windows Networking Vpn Plugin Platform/Operational'  
$wineventlog.IsEnabled = $true
$wineventlog.SaveChanges()

Write-Host -Object 'Enabling Windows Networking VPN Operational Verbose Logs'  -ForegroundColor Green

$wineventlog = Get-WinEvent -ListLog 'Windows Networking Vpn Plugin Platform/OperationalVerbose' 
$wineventlog.IsEnabled = $true 
$wineventlog.SaveChanges()

Write-Host -Object "The Logs have now been enabled, you can leave this application open to export the logs when you have an issue or close it if you don't need to export them!"  -ForegroundColor Green

Write-Host -NoNewline -Object 'Press any key to export the logs for analysis...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

Write-Host -Object 'Waiting for 10 more seconds to collect more logs...'  -ForegroundColor Green
Start-Sleep -Seconds 10
Write-Host -Object 'Exporting Event Logs for the VPN...'  -ForegroundColor Green

Copy-Item "$ENV:SystemRoot\System32\Winevt\Logs\Windows Networking Vpn Plugin Platform%4Operational.evtx" $path -Force
Copy-Item "$ENV:SystemRoot\System32\Winevt\Logs\Windows Networking Vpn Plugin Platform%4OperationalVerbose.evtx" $path -Force
Copy-Item "$ENV:SystemRoot\System32\Winevt\Logs\Microsoft-Windows-VPN-Client%4Operational.evtx" $path -Force
Copy-Item "$ENV:SystemRoot\System32\Winevt\Logs\Microsoft-Windows-DNS-Client%4Operational.evtx" $path -Force


Write-Host -Object 'Exporting IP Configuration...'  -ForegroundColor Green

& "$env:windir\system32\ipconfig.exe" /all > $path\"$Computer"_ipconfig1.txt

Write-Host -Object 'Stopping PowerShell Logging...'  -ForegroundColor Green

Stop-Transcript
Write-Host -Object 'Zipping up log files...'  -ForegroundColor Green

Remove-Item  -Path "c:\temp\VPNLogs+$Computer.zip" -Force | Out-Null

$LogSource = "$env:HOMEDRIVE\temp\" 
$ZipFileName = "VPNLogs+$Computer.zip"

Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::CreateFromDirectory($path, $LogSource+$ZipFileName)

Write-Host -Object 'Attempting to email log files to ITServiceDesk/Cloud & Enterprise mailboxes...'  -ForegroundColor Green
$IP = Get-NetIPConfiguration | Out-String

$Email = New-Object -ComObject 'CDO.Message'
$Email.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendusing') = 2
$Email.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserver') = 'smtprelay.domain.co.nz'
$Email.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserverport') = 25
$Email.Configuration.Fields.Update()

$Email.From = "$Computer@domain.co.nz"
$Email.To = 'supportdesk@@domain.co.nz'
$Email.Subject = "$Computer - VPN Logs $date"
$Email.TextBody  = "$IP"
#$Email.AddAttachment($file)
$Email.Send()

Write-Host -Object 'Client IP should be sent, Logs are stored in c:\temp!'  -ForegroundColor Green
