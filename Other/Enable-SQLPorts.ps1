function Enable-SQLPorts
{
  <#
      .SYNOPSIS
      Enables Microsoft SQL Server Firewall Ports
      .EXAMPLE
      Enable-SQLPorts

  #>
  
  #Enabling SQL Server Ports
  New-NetFirewallRule -DisplayName 'SQL Server' -Direction Inbound -Protocol TCP -LocalPort 1433 -Action allow
  New-NetFirewallRule -DisplayName 'SQL Admin Connection' -Direction Inbound -Protocol TCP -LocalPort 1434 -Action allow
  New-NetFirewallRule -DisplayName 'SQL Database Management' -Direction Inbound -Protocol UDP -LocalPort 1434 -Action allow
  New-NetFirewallRule -DisplayName 'SQL Service Broker' -Direction Inbound -Protocol TCP -LocalPort 4022 -Action allow
  New-NetFirewallRule -DisplayName 'SQL Debugger/RPC' -Direction Inbound -Protocol TCP -LocalPort 135 -Action allow
  #Enabling SQL Analysis Ports
  New-NetFirewallRule -DisplayName 'SQL Analysis Services' -Direction Inbound -Protocol TCP -LocalPort 2383 -Action allow
  New-NetFirewallRule -DisplayName 'SQL Browser' -Direction Inbound -Protocol TCP -LocalPort 2382 -Action allow
  #Enabling Misc. Applications
  New-NetFirewallRule -DisplayName 'HTTP' -Direction Inbound -Protocol TCP -LocalPort 80 -Action allow
  New-NetFirewallRule -DisplayName 'SSL' -Direction Inbound -Protocol TCP -LocalPort 443 -Action allow
  New-NetFirewallRule -DisplayName 'SQL Server Browse Button Service' -Direction Inbound -Protocol UDP -LocalPort 1433 -Action allow
  #Enable Windows Firewall
  Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
}

Enable-SQLPorts
