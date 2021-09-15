#Simple script to change Windows Hello PINComplexity to: Minimum of 4 chars, not 6.
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork\PINComplexity' -Force
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork\PINComplexity' -Name 'MinimumPINLength' -Value 4 -PropertyType DWord -Force 
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork\PINComplexity' -Name 'MaximumPINLength' -Value 10 -PropertyType DWord -Force 