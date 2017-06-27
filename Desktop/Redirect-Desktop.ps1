$newPath = 'E:\Desktop'  
$key1 = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'  
$key2 = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'  
set-ItemProperty -Path $key1 -Name Desktop -Value $newPath  
set-ItemProperty -Path $key2 -Name Desktop -Value $newPath
