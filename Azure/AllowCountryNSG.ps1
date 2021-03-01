#requires -Version 3.0 -Modules Az.Network
function Get-OdCountryIpAddressCidrList 
{
  [CmdletBinding(
      DefaultParameterSetName = 'code'
  )]
  param (
    # ISO 3166 country
    [Parameter(
        ParameterSetName = 'country'
    )]
    [string[]]
    $CountryName,

    # ISO 3166 2 character code
    [Parameter(
        ParameterSetName = 'code'
    )]
    [string[]]
    $CountryAlpha2Code,

    # IP protocol
    [Parameter(
        Mandatory
    )]
    [ValidateSet('Ipv4', 'Ipv6')]
    [string]
    $Protocol
  )

  begin {
    $ErrorActionPreference = 'stop'
    try 
    {
      $CountryCodeUrl = 'https://restcountries.eu/rest/v2/all'
      $Iso3166CountryList = Invoke-RestMethod -Uri $CountryCodeUrl -Verbose:$false -ErrorAction Stop
      $date = Get-Date -Format 's'
      $CountryList = [System.Collections.Generic.List[psobject]]::new()
    }
    # NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
    # some InvocationInfo details such as ScriptLineNumber.
    # REMEDY: If that affects you, remove the SPECIFIC exception type [System.ArgumentException] in the code below
    # and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
    # add the logic to handle different error types differently by yourself.
    catch [System.ArgumentException]
    {
      # get error record
      [Management.Automation.ErrorRecord]$e = $_

      # retrieve information about runtime error
      $info = [PSCustomObject]@{
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
      }
          
      # output information. Post-process collected info, and log info (optional)
      $info
    }
    catch 
    {
      $PSCmdlet.WriteError(
        $PSItem
      )
    }
  }

  process {
    $ErrorActionPreference = 'stop'
    try 
    {
      if ($PSCmdlet.ParameterSetName -eq 'country') 
      {
        foreach ($name in $CountryName) 
        {
          $country = $Iso3166CountryList | Where-Object -Property name -EQ -Value $name
          if ($country) 
          {
            $CountryList.Add($country)
          }
          else 
          {
            $CountryNotFoundMessage = "Cound not find ISO 3166-2 country '$name'. ISO 3166-2 list retrieved from $CountryCodeUrl on $date."
            Write-Error -Message $CountryNotFoundMessage
          }
        }
      }
      else 
      {
        foreach ($code in $CountryAlpha2Code) 
        {
          $country = $Iso3166CountryList | Where-Object -Property alpha2Code -EQ -Value $code
          if ($country) 
          {
            $CountryList.Add($country)
          }
          else 
          {
            $CodeNotFoundMessage = "Cound not find ISO 3166-2 country code for '$code' in list. ISO 3166-2 list retrieved from $CountryCodeUrl on $date."
            Write-Error -Message $CodeNotFoundMessage
          }
        }
      }
    }
    catch 
    {
      $PSCmdlet.WriteError(
        $PSItem
      )
    }
  }

  end {
    $ErrorActionPreference = 'stop'
    try 
    {
      $headers = @{
        Accept = 'application/vnd.github.v3.raw'
      }
      $IpList = foreach ($entry in $CountryList) 
      {
        $IsoCode = $entry.alpha2Code
        $IsoName = $entry.Name
        $path = '{0}/{1}.cidr' -f $Protocol, $IsoCode
        [uri]$uri = 'https://api.github.com/repos/herrbischoff/country-ip-blocks/contents/{0}' -f $path.ToLower()
        Write-Verbose -Message "Retrieving country IPs for $IsoName ($IsoCode)"
        [PSCustomObject][ordered]@{
          Country        = $IsoName
          Code           = $IsoCode
          TopLevelDomain = $entry.topLevelDomain
          CidrList       = ((Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -Verbose:$false).Split([System.Environment]::NewLine, [System.StringSplitOptions]::RemoveEmptyEntries) -split "`n").Trim()
          CidrListSource = 'https://github.com/herrbischoff/country-ip-blocks/blob/master/{0}' -f $path.ToLower()
        }
      }
      $IpList | Sort-Object -Property Code
    }
    catch 
    {
      $PSCmdlet.WriteError(
        $PSItem
      )
    }
  }
}

$CountryCodeUrl = 'https://restcountries.eu/rest/v2/all'
$Iso3166CountryList = Invoke-RestMethod -Uri $CountryCodeUrl -Verbose:$false
$nsg = Get-AzNetworkSecurityGroup -Name 'LOL'
$port = 8081
            
ForEach ($country in $Iso3166CountryList)
{
  $CountryName = $country.name      
  
  If ($CountryName -eq "New Zealand") {
  $CN = $country.alpha2Code
  
  $IPRanges = Get-OdCountryIpAddressCidrList -Protocol Ipv4 -CountryAlpha2Code $CN
  $IPRangeCidr = $IPRanges.CidrList 
              
  ForEach ($range in $IPRangeCidr)
    
  {
    IF ($count -eq $null)

    {
      $count = 1
    }

 
    $char = ([char](96 + $count))
    $count++
      
    IF ($priority -eq $null)

    {
      $priority = 100
    }

 
    $priority++
                               
    $nsg | Add-AzNetworkSecurityRuleConfig -Name "Allow_$($CN)_$($char)" -Description "Allows access from $Countryname" -Access Allow `
    -Protocol * -Direction Inbound -Priority $priority -SourceAddressPrefix "$range" -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange *
              
    $nsg | Set-AzNetworkSecurityGroup
  }}
}

