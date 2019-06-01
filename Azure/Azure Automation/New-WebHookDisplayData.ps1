
Param
(
  [object]$WebhookData
)

if ($WebhookData) {

  
  if (-Not $WebhookData.RequestBody) {
    Write-Output 'No request body from test pane'
    $WebhookData = (ConvertFrom-JSON -InputObject $WebhookData)

    Write-Output "WebhookData = $WebhookData"
    $data = (ConvertFrom-JSON -InputObject $WebhookData.RequestBody)
    Write-Output "Service = $($data.Service)"
    Write-Output "Host = $($data.Host)"

    Return
  }

  $request = (ConvertFrom-JSON -InputObject $WebhookData.RequestBody)
  $data = (ConvertFrom-JSON -InputObject $request.RequestBody)
  Write-Output "Service = $($data.Service)"
  Write-Output "Host = $($data.Host)"
}
Else {
  Write-Output 'No data received'
}