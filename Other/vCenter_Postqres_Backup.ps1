  <#
    .SYNOPSIS
    Backup a VMWare vCenter Postqres DB
    .DESCRIPTION
    Backup a VMWare vCenter Postqres DB. Quick/Basic script to be ran from a Scheduled Task using the VMWare Postqres Backup scripts - https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2091961
    Change the $postqrespwd variable to match your vCenter Postqres password that can be found here: C:\ProgramData\VMware\vCenterServer\cfg\vmware-vpx\vcdb.properties
    .AUTHOR
    Luke Murray (Luke.geek.nz)

  #>
$Date = Get-Date -format m
$postqrespwd = 'VCDBPassword'
& 'C:\Program Files\VMware\vCenter Server\python\python.exe' C:\temp\2091961_windows_backup_restore\backup_win.py -p $postqrespwd -f C:\Backups\backup_VCDB.$Date.bak
