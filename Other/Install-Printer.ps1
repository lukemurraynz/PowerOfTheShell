
<#

    Author:  Luke Murray (http://Luke.Geek.NZ)
    Version: 0.1

    Purpose: To install a network printer for all users, using Windows servers and sets the Default page size from Letter to A4.
    The variables will need to be changed depending on your environment.

#>

#Sets Printer variables

$printer = 'PrinterName'
$Driver = 'RICOH PCL6 UniversalDriver V4.11'
$port = '\\Server\Printer'
$PaperSize = 'A4' 

#Creates Printer Port

try
{
  $null = Add-PrinterPort -Name $port -PrinterHostAddress $port -ErrorAction Stop
  Write-Verbose -Message "The following port: $port has been created."  -Verbose
}

catch [Microsoft.Management.Infrastructure.CimException]
{
  [Management.Automation.ErrorRecord]$e = $_


  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
  }
  
  Write-Verbose -Message $info  -Verbose
}

#Creates new printer using the port created in the last step

try
{
  $null = Add-Printer -Name $printer -DriverName $Driver -PortName $port -ErrorAction Stop
  Write-Verbose -Message "The following printer: $printer has been created."  -Verbose
}
catch [Microsoft.Management.Infrastructure.CimException]
{
  [Management.Automation.ErrorRecord]$e = $_

  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
  }
  
  Write-Verbose -Message $info -Verbose
}

#Sets Printer as Default Printer

$printer = $printer.Replace('\','\\')
$printobj = (Get-WmiObject -Class win32_printer -Filter "Name='$printer'")
$printobj.SetDefaultPrinter()

#Configures the Printer to A4
 
$objPrinter = Get-PrintConfiguration -PrinterName $printer  
$strPaperSize = $objPrinter.PaperSize 
 
If ($strPaperSize -ne $PaperSize) 
{ 
  Set-PrintConfiguration -PrinterName $printer -PaperSize $PaperSize 
     
  $objPrinter = Get-PrintConfiguration -PrinterName $printer 
  $strPaperSizeUpdated = $objPrinter.PaperSize 
  $strPaperSizeUpdated 
 
  Write-Verbose -Message "The paper size was changed as follows: 
    From:  $strPaperSize 
  To:  $strPaperSizeUpdated" -Verbose
} 
Else 
{
  Write-Verbose -Message "The following printer: $printer has been created." -Verbose
}