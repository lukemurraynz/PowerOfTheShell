#requires -Version 2.0
  <#
      Author: Luke Murray (Luke.Geek.NZ)
      Version: 0.1
      Purpose: Drains cluster resources from primary node to secondary.
  #>

Import-Module -Name FailoverClusters
$computer = Get-Content -Path env:computername
$computer = $computer.ToLower()
$destnode = Get-ClusterNode | Select-Object -Property Name

[string]$drainnode = ($destnode.Name -ne $computer) 

Get-ClusterGroup |
ForEach-Object `
-Process {
  If ($_.Name -ne $computer)
  {
    Move-ClusterGroup -Name $_.Name -Node $drainnode
  }
}
	
-Process {
  If ($_.Name -ne $computer)
  {
    Move-ClusterGroup -Name $_.Name -Node $computer
  }
}
