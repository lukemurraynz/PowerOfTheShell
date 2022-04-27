$Today = Get-Date
$Year = $Today.Year
$CountryCode = 'NZ'
#read the content from nager.date
$url = "https://date.nager.at/api/v2/publicholidays/$Year/$CountryCode"
Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Holidays = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $url

Write-Output $Holidays
