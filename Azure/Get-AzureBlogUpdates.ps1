function Get-AzureBlogUpdates {
    <#
      .SYNOPSIS
      Retrieves the latest Updates of Azure, from the Azure Blog RSS feed.
      .DESCRIPTION
      Retrieves the latest Updates of Azure, from the Azure Blog RSS feed.
      .NOTES
      Version:        1.0
      Author:         Luke Murray (Luke.Geek.NZ)
      Creation Date:  03.04.21
      Purpose/Change: 
      03.04.21 - Intital script development
      .EXAMPLE
      Get-AzureBlogUpdate

  #>
    $xml = [xml](Invoke-WebRequest -Uri 'https://azurecomcdn.azureedge.net/en-us/updates/feed/').content
    $Array = @()
    foreach ($y in $xml.rss.channel.selectnodes('//item'))
    {
        $PSObject = New-Object -TypeName PSObject
        $Date = [datetime]$y.pubdate
        $PSObject | Add-Member NoteProperty 'Title'  $y.title
        $PSObject | Add-Member NoteProperty 'Date' $Date
        $PSObject | Add-Member NoteProperty 'Category'  $y.category
        $PSObject | Add-Member NoteProperty 'Description'  $y.content.InnerText
        $PSObject | Add-Member NoteProperty 'Link'   $y.link
    
    
        $Array += $PSObject
    } 
  
    $results = @()
    ForEach ($item in $Array) {
        $Category = Foreach ($title in $item.Title)
        {
            $results += [pscustomobject]@{
                'Title'          = $item.Title
                'Category'       = $item.Category -join ',' | Select-Object -Unique
                'Published Date' = $item.Date
                'Description'    = $item.Description
                'Link'           = $item.Link
            }
        }
    }
    $results
}

#Runs the Function:
Get-AzureBlogUpdates

#EXAMPLE - Gets Azure Blog Updates, that have been published in the last 7 days. 
$PublishedIntheLastDays = (Get-Date).AddDays(-7)
Get-AzureBlogUpdates | Where-Object 'Published Date' -GT $PublishedIntheLastDays

#EXAMPLE - Gets all Azure Blog Updates, and displays it as a Table, organised by Category
Get-AzureBlogUpdates | Sort-Object Category -Descending | Format-Table

#EXAMPLE -Gets the latest 10 Azure Blog Articles
Get-AzureBlogUpdates | Select -Last 10

#EXAMPLE - Gets the Azure Blog Update articles, where the title has Automation in it.
Get-AzureBlogUpdates | Where-Object Title -match 'Automation' 