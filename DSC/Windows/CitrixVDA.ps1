Configuration CitrixVDA
{
    Import-DscResource -ModuleName 'PSDesiredStategConfiguration'
    Import-DscResource -ModuleName 'xDSCDomainjoin'
param
     (
    $dscDomainAdmin = Get-AutomationPSCredential -Name 'Default Automation Credential'
    $storageCredentials = Get-AutomationPSCredential -Name 'Default Automation Credential'
    [string] $dscDomainName = "luke.geek.nz"
    $sourceserver = 'SourceServer01'
    )
    Node $env:COMPUTERNAME
    {
         #Joins the Domain
        xDSCDomainjoin JoinDomain
        {
             If ($env:COMPUTERNAME -contains "-C-")
             {
             
            Domain = $dscDomainName
            Credential = $dscDomainAdmin
            JoinOU = "OU=Citrix,OU=Servers,OU=Systems,DC=luke,DC=geek,DC=nz"
               }    

          #Installs Windows Feature
        WindowsFeature 'Telnet-Client'
        {
             Name   = 'Telnet-Client'
             Ensure = 'Present'
        }

        
        WindowsFeature 'RDS-RD-Server'
        {
             Name   = 'RDS-RD-Server'
             Ensure = 'Present'
        }

        WindowsFeature 'WebDAV-Redirector'
        {
             Name   = 'WebDAV-Redirector'
             Ensure = 'Present'
        }

        WindowsFeature 'RSAT-AD-Tools'
        {
             Name   = 'RSAT-AD-Tools'
             Ensure = 'Present'
        }

     # .NET 3.5 Installs
     File NETSource {
          Type = "directory"
          DestinationPath = "C:\Temp\NETSource"
          Ensure = "Present"
         }

      File DotNet351SXS {
         Credential = $storageCredentials
         DestinationPath = "C:\NETSource\microsoft-windows-netfx3-ondemand-package.cab"
         SourcePath = "\\$sourceserver\CitrixVDABuild\sxs\microsoft-windows-netfx3-ondemand-package.cab"
          Type = "File"
          Ensure = "Present"
          DependsOn = "[File]NETSource"
         }

         WindowsFeature DotNET351 {
          Name = "NET-Framework-Core"
          Ensure = "present"
          Source = "C:\temp\NETSource"
          DependsOn = "[File]DotNet351SXS"
         }
        #Remove Windows Features
        WindowsFeature 'Windows-Defender'
        {
             Name   = 'Windows-Defender'
             Ensure = 'Absent'
        }
        WindowsFeature 'Windows-Defender-GUI'
        {
             Name   = 'Windows-Defender-GUI'
             Ensure = 'Absent'
        }

    }


}