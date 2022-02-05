$allvms = Get-AzVM
$applicationname = 'DattoRMM'
$galleryname = 'AzComputeGallery'
$galleryrg = 'vmapps-prod-rg'
$appversion = '0.0.1'

  
try
{
  ForEach ($vm in $allvms)

  {
    $AzVM = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
    $appversion = Get-AzGalleryApplicationVersion `
    -GalleryApplicationName $applicationname `
    -GalleryName $galleryname `
    -Name $appversion `
    -ResourceGroupName $galleryrg
    $packageid = $appversion.Id
    $app = New-AzVmGalleryApplication -PackageReferenceId $packageid
    Add-AzVmGalleryApplication -VM $AzVM -GalleryApplication $app
    Update-AzVM -ResourceGroupName $vm.ResourceGroupName -VM $AzVM -ErrorAction Stop
  }
}

catch [Microsoft.Azure.Commands.Compute.Common.ComputeCloudException]
{
  #Most likely failed due to duplicate package ID/identical version
  [Management.Automation.ErrorRecord]$e = $_

  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
  }

  $info
}

