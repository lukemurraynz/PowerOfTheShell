if ( (Test-Path -Path $env:windir\System32\MicTray64.exe) -or (Test-Path -Path $env:windir\System32\MicTray.exe) ) { 

    Remove-Item -Path $env:windir\System32\MicTray64.exe -ErrorAction SilentlyContinue
    Remove-Item -Path $env:windir\System32\MicTray.exe -ErrorAction SilentlyContinue
    Remove-Item -Path $env:PUBLIC\MicTray.log -ErrorAction SilentlyContinue
    Write-Verbose -Message True -Verbose
}
else
 {
  Write-Verbose -Message False -Verbose
 }
