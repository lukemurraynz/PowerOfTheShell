dir |
Where-Object { $_.name.Contains(" ") } |
Rename-Item -NewName { $_.name -replace " ","_"}