
$serviceName = 'CSFalconService'
$service = Get-Service -Name $ServiceName

if ($service.Status -ne 'Running'){

[reflection.assembly]::loadwithpartialname('System.Windows.Forms')
[reflection.assembly]::loadwithpartialname('System.Drawing')
$notify = new-object system.windows.forms.notifyicon
$notify.icon = [System.Drawing.SystemIcons]::Error
$notify.visible = $true
$notify.BalloonTipTitle = 'Crowdstrike is NOT running'
$notify.BalloonTipText = 'Crowdstrike is NOT running'
$notify.Text = 'Crowdstrike is NOT running'
$Notify.ShowBalloonTip(2500,$serviceName,"Crowdstrike is NOT running.",[system.windows.forms.tooltipicon]::Info)

}

Else

{
[reflection.assembly]::loadwithpartialname('System.Windows.Forms')
[reflection.assembly]::loadwithpartialname('System.Drawing')
$notify = new-object system.windows.forms.notifyicon
$notify.icon = [System.Drawing.SystemIcons]::Information
$notify.visible = $true
$notify.BalloonTipTitle = 'Crowdstrike is running'
$notify.BalloonTipText = 'Crowdstrike is running'
$notify.Text = 'Crowdstrike is running'
$Notify.ShowBalloonTip(2500,$serviceName,"Crowdstrike is running.",[system.windows.forms.tooltipicon]::Info)

}

