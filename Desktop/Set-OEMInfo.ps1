<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Purpose: To add in basic OEM Info into the registry. 
#>

Function Set-OEMInfo
    {  
        $OEMKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation'   
        Set-ItemProperty -Path $OEMKey -Name 'Model' -Value (Get-WmiObject -Class Win32_ComputerSystem).Model   
        Set-ItemProperty -Path $OEMKey -Name 'HelpCustomized' -Value 00000000   
        Set-ItemProperty -Path $OEMKey -Name 'SupportHours' -Value '7AM - 5PM'   
        Set-ItemProperty -Path $OEMKey -Name 'Manufacturer' -Value 'Company Name'   
        Set-ItemProperty -Path $OEMKey -Name 'SupportPhone' -Value '0118 999 881'  
        Set-ItemProperty -Path $OEMKey -Name 'SupportURL' -Value 'https://www.luke.geek.nz/'  
    }

Set-OEMInfo