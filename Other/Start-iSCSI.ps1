# Check if the script is running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "Please run this script with administrative privileges."
    exit
}

# Set the service name
$serviceName = "MSiSCSI"

# Check if the service exists
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($service -eq $null) {
    Write-Host "The '$serviceName' service does not exist on this system."
    exit
}

# Check if the service is already running
if ($service.Status -eq "Running") {
    Write-Host "The '$serviceName' service is already running."
} else {
    # Start the service
    Start-Service -Name $serviceName
    Write-Host "The '$serviceName' service has been started."
}

# Set the service startup type to Automatic
Set-Service -Name $serviceName -StartupType Automatic
Write-Host "The '$serviceName' service has been set to Automatic startup."
