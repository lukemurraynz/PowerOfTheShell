#requires -Version 1
Function Cleanup {
    function global:Write-Verbose ([string]$Message)
	
    # check $VerbosePreference variable, and turns -Verbose on 
    {
    if ($VerbosePreference -ne 'SilentlyContinue') {
        Write-Host -Object " $Message" -ForegroundColor 'Yellow'
    }
}
	
$OperatingSystemVersion = (Get-WmiObject -Class Win32_OperatingSystem).Version    

$VerbosePreference = 'Continue'
$DaysToDelete = 7
$LogDate = Get-Date -Format 'MM-d-yy-HH'
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace(0xA)
$ErrorActionPreference = 'silentlycontinue'
	
Start-Transcript -Path C:\Windows\Temp\$LogDate.log
	
## Cleans all code off of the screen.
Clear-Host
	
$Before = Get-WmiObject Win32_LogicalDisk |
    Where-Object -FilterScript {
    $_.DriveType -eq '3'
} |
    Select-Object -Property SystemName,
@{
    Name       = 'Drive'
    Expression = {
        ($_.DeviceID)
    }
},
@{
    Name       = 'Size (GB)'
    Expression = {
        '{0:N1}' -f ($_.Size / 1gb)
    }
},
@{
    Name       = 'FreeSpace (GB)'
    Expression = {
        '{0:N1}' -f ($_.Freespace / 1gb)
    }
},
@{
    Name       = 'PercentFree'
    Expression = {
        '{0:P1}' -f ($_.FreeSpace / $_.Size)
    }
} |
    Format-Table -AutoSize |
    Out-String
	
## Stops the windows update service. 
Get-Service -Name wuauserv | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue
## Windows Update Service has been stopped successfully!
	
## Stops the Microsoft Monitoring service. 
Get-Service -Name HealthService | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue
## Microsoft Monitoring Service has been stopped successfully!
	
## Stops the TrustedInstaller service. 
Get-Service -Name TrustedInstaller | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue
## Windows Update Service has been stopped successfully!
	
## Deletes SCCM Cache.
Get-ChildItem 'c:\Windows\ccmcache\*' -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -lt $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -Verbose -recurse -ErrorAction SilentlyContinue
	
## Deletes the contents of windows software distribution.
Get-ChildItem 'C:\Windows\SoftwareDistribution\*' -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -lt $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -Verbose -recurse -ErrorAction SilentlyContinue
## The Contents of Windows SoftwareDistribution have been removed successfully!
	
## Deletes the contents of Microsoft Monitoring Cache (SCOM Cache).
Get-ChildItem 'C:\Program Files\Microsoft Monitoring Agent\Agent\Health Service State\*' -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -lt $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -Verbose -recurse -ErrorAction SilentlyContinue
## The Contents of SCOM Cache have been removed successfully!
	
## Deletes the contents of the Windows Temp folder.
Get-ChildItem 'C:\Windows\Temp\*' -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -lt $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -Verbose -recurse -ErrorAction SilentlyContinue
## The Contents of Windows Temp have been removed successfully!
	
## Deletes the contents of TrustedInstaller CBS folder.
Get-ChildItem 'C:\Windows\Logs\CBS\*' -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -lt $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -Verbose -recurse -ErrorAction SilentlyContinue
## The Contents of Windows SoftwareDistribution have been removed successfully!
	
## Delets all files and folders in user's Temp folder. 
Get-ChildItem 'C:\users\*\AppData\Local\Temp\*' -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -lt $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -Verbose -recurse -ErrorAction SilentlyContinue
## The contents of C:\users\$env:USERNAME\AppData\Local\Temp\ have been removed successfully!
	
## Remove all files and folders in user's Temporary Internet Files. 
Get-ChildItem 'C:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*' `
    -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -le $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -recurse -ErrorAction SilentlyContinue
## All Temporary Internet Files have been removed successfully!
	
## Cleans IIS Logs if applicable.
Get-ChildItem 'C:\inetpub\logs\LogFiles\*' -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -le $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue
## All IIS Logfiles over x days old have been removed Successfully!

## Deletes the Microsoft Azure Extension Logs.
Get-ChildItem 'C:\WindowsAzure*' -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.CreationTime -lt $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -force -Verbose -recurse -ErrorAction SilentlyContinue
    
## Cleans VMWare Horizon Logs if applicable.
Get-ChildItem 'C:\ProgramData\VMware\vCenterServer\logs\*' -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object -FilterScript {
    ($_.LastWriteTime -le $(Get-Date).AddDays( - $DaysToDelete))
} |
    Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue
	
## deletes the contents of the recycling Bin.
## The Recycling Bin is now being emptied!
$objFolder.items() | ForEach-Object -Process {
    Remove-Item $_.path -ErrorAction Ignore -Force -Verbose -Recurse
}
## The Recycling Bin has been emptied!
    
## Runs DISM cleanup
## Windows 8.1 / Server 2012 R2 / Windows 10 / Server 2016


switch  -Regex ($OperatingSystemVersion) {
    '(^10\.0.*|^6\.3.*)' {

        dism.exe /online /Cleanup-Image /StartComponentCleanup
    }
}
{
    continue
}
	
## Starts the Windows Update Service
Get-Service -Name wuauserv | Start-Service -Verbose
	
## Starts the SCOM Service
Get-Service -Name HealthService | Start-Service -Verbose
	
## Starts the TrustedInstaller Service
Get-Service -Name TrustedInstaller | Start-Service -Verbose
	
$After = Get-WmiObject Win32_LogicalDisk |
    Where-Object -FilterScript {
    $_.DriveType -eq '3'
} |
    Select-Object -Property SystemName,
@{
    Name       = 'Drive'
    Expression = {
        ($_.DeviceID)
    }
},
@{
    Name       = 'Size (GB)'
    Expression = {
        '{0:N1}' -f ($_.Size / 1gb)
    }
},
@{
    Name       = 'FreeSpace (GB)'
    Expression = {
        '{0:N1}' -f ($_.Freespace / 1gb)
    }
},
@{
    Name       = 'PercentFree'
    Expression = {
        '{0:P1}' -f ($_.FreeSpace / $_.Size)
    }
} |
    Format-Table -AutoSize |
    Out-String
	
## Sends some before and after:
	
HOSTNAME.EXE
Get-Date | Select-Object -Property DateTime
Write-Verbose -Message "Before: $Before"
Write-Verbose -Message "After: $After"
Stop-Transcript
## Completed Successfully!
	
## Send Email to mailbox
$file = "C:\Windows\Temp\$LogDate.log"
$att = New-Object -TypeName Net.Mail.Attachment -ArgumentList ($file)
$Message = New-Object -TypeName System.Net.Mail.MailMessage
$Message.From = 'DiskCleanup@contoso.com'
$Message.To.Add('Operations@contoso.com')
$Message.Subject = HOSTNAME.EXE
'Disk Cleanup'
$Message.Body = $Message.Attachments.Add($att)
	
$smtp = New-Object -TypeName System.net.Mail.SmtpClient
$smtp.Host = "smtp.contoso.com"
$smtp.UseDefaultCredentials = $true
$smtp.Send($Message)
}
Cleanup
