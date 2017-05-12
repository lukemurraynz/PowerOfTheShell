if ( (Test-Path C:\Windows\System32\MicTray64.exe) -or (Test-Path C:\Windows\System32\MicTray.exe) ) { 
  Write-Verbose True -Verbose
}
else
 {Write-Verbose False -Verbose
 }

#Remove-Item C:\Windows\System32\MicTray64.exe  | Out-Null
#Remove-Item C:\Windows\System32\MicTray.exe -Force | Out-Null
#Remove-Item C:\Users\Public\MicTray.log -Force | Out-Null


