$todaydt = Get-Date
$years = $todaydt.AddYears(3)

#Creates RootCA
$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature -Subject "CN=LUKEROOT" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign
#Creates Cert
New-SelfSignedCertificate -Type Custom -DnsName OverKill -KeySpec Signature -Subject "CN=OVERKILL" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -notafter $years -CertStoreLocation "Cert:\CurrentUser\My" -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")