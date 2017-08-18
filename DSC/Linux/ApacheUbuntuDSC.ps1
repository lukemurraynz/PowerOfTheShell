#requires -Version 4.0
<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Purpose: Installing Apache/PHP 7.0 using Linux Desired State Configuration on Ubuntu Server.
#>

Configuration ApacheUbuntuDSC
{

    Import-DSCResource -Module nx  
    
    Node "localhost"
    
       {
 
    
         nxPackage apache
         {
            DependsOn      = '[nxPackage]php'
            Name           = 'apache2'
            Ensure         = 'Present'
            PackageManager = 'Apt'
         }

            nxPackage php
         {       
            Name           = 'php7.0 libapache2-mod-php7.0 php-memcached php7.0-pspell php7.0-curl php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring'
            Ensure         = 'Present'
            PackageManager = 'Apt'
         }

            nxPackage sql
         {       
            Name           = 'mysql-client mysql-server libpq5 php7.0-pgsql'
            Ensure         = 'Present'
            PackageManager = 'Apt'
         }

            nxService apache2Service
         {
            Name       = 'apache2'
            Controller = 'systemd'
            Enabled    = $true
            State      = 'Running'
            DependsOn  = '[nxPackage]Apache'
         }    

         nxPackage additionalpackages
         {       
            DependsOn      = '[nxPackage]Apache'
            Name           = "graphviz aspell"
            Ensure         = "Present"
            PackageManager = "Apt"
            }

                nxFile PHPInfo
         {
            DependsOn       = '[nxPackage]Apache'
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = '/var/www/html/phpinfo.php'
            Contents        = "<?php `nphpinfo(); `n?>"
         }


    }
}


#ApacheUbuntuDSC -OutputPath: "C:\Temp\DSC\"