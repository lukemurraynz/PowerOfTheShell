﻿# Config
New-Item c:\temp -ItemType Directory -Force
$logFileName = "Application" # Add Name of the Logfile (System, Application, etc)
$path = "C:\temp\" # Add Path, needs to end with a backsplash
 
# do not edit
$exportFileName = $logFileName + (get-date -f yyyyMMdd) + ".evt"
$logFile = Get-WmiObject Win32_NTEventlogFile | Where-Object { $_.logfilename -eq $logFileName }
$logFile.backupeventlog($path + $exportFileName)

# Config
$logFileName = "System" # Add Name of the Logfile (System, Application, etc)
$path = "C:\temp\" # Add Path, needs to end with a backsplash
 
# do not edit
$exportFileName = $logFileName + (get-date -f yyyyMMdd) + ".evt"
$logFile = Get-WmiObject Win32_NTEventlogFile | Where-Object { $_.logfilename -eq $logFileName }
$logFile.backupeventlog($path + $exportFileName)