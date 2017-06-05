#requires -Version 2.0

$cred = Get-Credential
$computer = 'localhost'

Invoke-Command -ComputerName $computer -Credential $cred -ScriptBlock {

  $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'High Performance'"          

  Invoke-CimMethod -InputObject $p -MethodName Activate
}
