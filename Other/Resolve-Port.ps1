function Resolve-Port
{
  <#
    .SYNOPSIS
    Resolves Port Script. Script that checks to see if a server is up and responding to a specific port. This was 
    .DESCRIPTION
    Detailed Description
    .EXAMPLE
    Resolve-Port -server Server1 -port 3389
    Resolve-Port -server Server1,Server2,Server3 -port 3389
    .EXAMPLE
    Resolve-Port -server Server1 -port 3389
    .AUTHOR
    Luke Murray (Luke.Geek.NZ)
    Copied from: https://social.technet.microsoft.com/Forums/office/en-US/7a3304c7-b564-4acc-ab28-2648a20f4bce/telnet-using-powershell?forum=winserverpowershell and put into a Function.

  #>
  param
  (
    [Parameter(Position=0)]
    [string]
    $server = 'Server1',
    
    [Parameter(Position=1)]
    [string]
    $port = '3389'
  )
  
  foreach ($null in $server) {
    
    If ( Test-Connection -ComputerName $server -Count 1 -Quiet) {
      
      try {       
        $null = New-Object -TypeName System.Net.Sockets.TCPClient -ArgumentList $server,$port
        $props = @{
          Server = $server
          PortOpen = 'Yes'
        }
      }
      
      catch {
        $props = @{
          Server = $server
          PortOpen = 'No'
        }
      }
    }
    
    Else {
      
      $props = @{
        Server = $server
        PortOpen = 'Server did not respond to ping'
      }
    }
    
    New-Object -TypeName PsObject -Property $props
    
  }
}
