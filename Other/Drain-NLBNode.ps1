#requires -Version 2.0
  <#
      Author: Luke Murray (Luke.Geek.NZ)
      Version: 0.1
      Purpose: Stops and drains NLB cluster resources from primary node to secondaries, with a wait time of 30 minutes.
  #>

Import-Module -Name NetworkLoadBalancingClusters
Stop-NLBClusterNode -Drain -Timeout 30
