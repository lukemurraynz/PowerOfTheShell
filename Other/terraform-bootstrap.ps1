# terraform-bootstrap.ps1

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$TerraformPath = ".\terraform",
    
    [Parameter(Mandatory = $false)]
    [string]$TerraformVersion = "latest",
    
    [Parameter(Mandatory = $false)]
    [string]$ConfigPath = ".\config",
    
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".\output",
    
    [Parameter(Mandatory = $false)]
    [switch]$AutoApprove
)

# Function to ensure Terraform is installed
function Install-Terraform {
    param (
        [string]$version,
        [string]$path
    )
    
    # Get latest version if not specified
    if ($version -eq "latest") {
        $versionResponse = Invoke-WebRequest -Uri "https://checkpoint-api.hashicorp.com/v1/check/terraform"
        $version = ($versionResponse).Content | ConvertFrom-Json | Select-Object -ExpandProperty current_version
    }

    # Check if Terraform is already installed
    $tfCommand = Get-Command -Name terraform -ErrorAction SilentlyContinue
    if ($tfCommand) {
        Write-Verbose "Terraform already installed at $($tfCommand.Path)"
        return
    }

    # Create tools directory
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }

    # Download and extract Terraform
    $os = if ($IsWindows) { "windows" } else { if ($IsMacOS) { "darwin" } else { "linux" } }
    $arch = if ([System.Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }
    
    $url = "https://releases.hashicorp.com/terraform/$($version)/terraform_$($version)_${os}_${arch}.zip"
    $zipFile = Join-Path $path "terraform.zip"
    $extractPath = Join-Path $path "terraform_$version"

    Write-Verbose "Downloading Terraform from $url"
    Invoke-WebRequest -Uri $url -OutFile $zipFile
    
    Write-Verbose "Extracting Terraform to $extractPath"
    Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force
    Remove-Item $zipFile

    # Add to PATH
    $env:PATH = "$extractPath;$env:PATH"
}

# Function to run Terraform commands
function Invoke-Terraform {
    param (
        [string]$workingDirectory,
        [string]$command,
        [switch]$autoApprove
    )

    Push-Location $workingDirectory
    try {
        # Initialize
        Write-Host "Initializing Terraform..." -ForegroundColor Green
        terraform init

        # Run specified command
        Write-Host "Running terraform $command..." -ForegroundColor Green
        if ($command -eq "apply" -or $command -eq "destroy") {
            terraform plan -out=tfplan
            
            if (!$autoApprove) {
                $confirmation = Read-Host "Do you want to proceed with terraform $command? (y/n)"
                if ($confirmation -ne 'y') {
                    Write-Host "Operation cancelled" -ForegroundColor Yellow
                    return
                }
            }
            
            if ($command -eq "apply") {
                terraform apply -auto-approve tfplan
            }
            else {
                terraform destroy -auto-approve
            }
        }
        else {
            terraform $command
        }
    }
    finally {
        Pop-Location
    }
}

# Main script
try {
    # Create required directories
    if (!(Test-Path $ConfigPath)) {
        New-Item -ItemType Directory -Path $ConfigPath -Force | Out-Null
    }
    if (!(Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }

    # Install Terraform
    Write-Host "Ensuring Terraform is installed..." -ForegroundColor Green
    Install-Terraform -version $TerraformVersion -path $TerraformPath

    # Copy Terraform files from config to output directory
    Write-Host "Setting up Terraform workspace..." -ForegroundColor Green
    
    # Convert to absolute paths
    $ConfigPathFull = Resolve-Path $ConfigPath -ErrorAction Stop
    $OutputPathFull = Resolve-Path $OutputPath -ErrorAction Stop
    
    Write-Verbose "Config Path: $ConfigPathFull"
    Write-Verbose "Output Path: $OutputPathFull"
    
    $ConfigFiles = Get-ChildItem -Path $ConfigPathFull -Filter "*.tf" -ErrorAction Stop
    $VarFiles = Get-ChildItem -Path $ConfigPathFull -Filter "*.tfvars" -ErrorAction Stop
    
    Write-Verbose "Found $($ConfigFiles.Count) .tf files"
    
    foreach ($file in $ConfigFiles) {
        Write-Verbose "Processing file: $($file.FullName)"
        
        # Verify source file
        if (!(Test-Path $file.FullName)) {
            Write-Error "Source file not found: $($file.FullName)"
            continue
        }
        
        # Check file content
        $content = Get-Content $file.FullName -Raw
        if ([string]::IsNullOrWhiteSpace($content)) {
            Write-Warning "File is empty: $($file.FullName)"
            continue
        }
        
        Write-Verbose "Copying $($file.Name) to $OutputPathFull"
        Copy-Item -Path $file.FullName -Destination $OutputPathFull -Force
        
        # Verify copy succeeded
        $destFile = Join-Path $OutputPathFull $file.Name
        if (!(Test-Path $destFile)) {
            Write-Error "Failed to copy file to: $destFile"
        }
    }
    
    foreach ($file in $VarFiles) {
        Write-Verbose "Processing var file: $($file.FullName)"
        Copy-Item -Path $file.FullName -Destination $OutputPathFull -Force
    }

    
    # Run Terraform
    Write-Host "Running Terraform..." -ForegroundColor Green
    Invoke-Terraform -workingDirectory $OutputPath -command "apply" -autoApprove:$AutoApprove

}
catch {
    Write-Error "Error occurred: $_"
    exit 1
}
