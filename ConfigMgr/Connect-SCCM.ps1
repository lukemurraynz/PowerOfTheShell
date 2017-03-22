function Connect-SCCM
{
  <#
      .SYNOPSIS
      Connects to Configuration Manager Environment via PowerShell
      .DESCRIPTION
      Function designed to Connect to the SCCM Primary Site
      .EXAMPLE
      Connect-SCCM
      .AUTHOR
      Luke Murray

  #>
  #requires -Version 2.0
  #Note Config Manager must be installed before the Set-Location will work.
  #Also the psd1 file calls a ps1xml file and the server must have it's execution policy must be allowed to run it.
  Import-Module -Name 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1' 
  #Change site code to your your own environment.
  $sitecode = 'WNT:'
  Set-Location -Path $sitecode
}

Connect-SCCM
