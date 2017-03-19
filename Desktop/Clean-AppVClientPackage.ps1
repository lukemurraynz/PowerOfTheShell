#requires -Modules AppvClient
#requires -Version 2.0 
<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: To remove unused App-V packages older than x30 days from a clients App-V package store. Intended to be used as a Configuration Manager baseline.
    http://luke.geek.nz/win/rm-unused-app-v-packages-powershell-sccm.
#>

$log = "$env:HOMEDRIVE\temp\$env:COMPUTERNAME".log
$Now = Get-Date 
$Days = 30
$TargetFolder = "$env:ProgramData\App-V" 
$LastAccessTime = $Now.AddDays(-$Days) 
$Files = Get-ChildItem -Path $TargetFolder  | Where-Object -FilterScript {
  $_.LastAccessTime -lt ('{0}' -f $LastAccessTime)
}  
$null = @() 
if ($Files.count -gt 0)
{
  ForEach ($null in $Files)
  { 
    Start-Transcript -Append -Path $log

    $Result = Get-AppvClientPackage | Where-Object -FilterScript {
      $_.Name -notlike 'Microsoft App-V*'
    } 
     
    foreach ($PackageId in $Result)
    
    {
      #The line below will remove unused packages. Please remove the '#' before the pipeline to actually remove packages.
      Get-AppvClientPackage -PackageId $PackageId.PackageID.Guid #| Remove-AppvClientPackage
    }
      
    foreach ($null in $TargetFolder)
    { 
      #The line below will remove  empty folders. Please remove the '#' before the pipeline to actually remove the folders.
      Get-ChildItem -Path $TargetFolder | Where-Object -FilterScript {
        $_.PSIsContainer -eq 'True' -and $_.GetFileSystemInfos().Count -eq 0
      } # |  Remove-Item
    }
    Write-Verbose -Message 'Non-Compliant' -Verbose
    Stop-Transcript
  } 
}
else
{
  Start-Transcript -Append -Path $log
  Write-Verbose -Message 'Compliant' -Verbose
  Stop-Transcript
}
