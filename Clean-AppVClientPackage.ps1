#requires -Modules AppvClient
#requires -Version 2.0 
<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: To removed unused App-V packages older than x30 days from a clients App-V package store. Intended to be used with Configuration Manager baslines.
	  http://luke.geek.nz/win/rm-unused-app-v-packages-powershell-sccm.
#>

$Now = Get-Date 
$Days = 30
$TargetFolder = "$env:ProgramData\App-V" 
$LastAccessTime = $Now.AddDays(-$Days) 
$Files = Get-ChildItem -Path $TargetFolder  | Where-Object -FilterScript { 
  $_.LastAccessTime -lt "$LastAccessTime" 
}  
$null = @() 
if ($Files.count -gt 0)
{
  ForEach ($null in $Files)
  { 
   Start-Transcript -Append -Path c:\temp\"$env:COMPUTERNAME".log

     $Result = Get-AppvClientPackage | Where-Object { $_.Name -notlike 'Microsoft App-V*'} 
     
    foreach ($PackageId in $Result)
    
    {
    
      Get-AppvClientPackage -PackageID $PackageId.PackageID.Guid #| Remove-AppvClientPackage
    }
      
    foreach ($null in $TargetFolder)
    { 
      Get-ChildItem -Path $TargetFolder | Where-Object {$_.PSIsContainer -eq 'True' -and $_.GetFileSystemInfos().Count -eq 0} |  Remove-Item
    }
    Write-Verbose -Message 'Non-Compliant' -Verbose
   Stop-Transcript
  } 
}
else
{
  Start-Transcript -Append -Path c:\temp\"$env:COMPUTERNAME".log
  Write-Verbose -Message 'Compliant' -Verbose
  Stop-Transcript
}
