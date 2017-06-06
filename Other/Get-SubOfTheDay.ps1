#requires -Version 3.0
function Get-SubOfTheDay
{
  <#
      .SYNOPSIS
      Retrieves Subs of the Days (NZ)
      .AUTHOR
      Luke Murray (http://Luke.Geek.NZ)
      .EXAMPLE
      Get-SubOfTheDay
      Get-SubOfTheDay -url https://www.subway.co.nz/sub-of-the-day
   #>
   
  param
  (
    [Parameter(Position=0)]
    [string]
    $url = 'https://www.subway.co.nz/sub-of-the-day'
  )
  
  $response = Invoke-WebRequest -Uri $url 
  $response.ParsedHtml.body.getElementsByClassName('navigation-item text-center') | Select-Object -ExpandProperty innerText
}

Get-SubOfTheDay
