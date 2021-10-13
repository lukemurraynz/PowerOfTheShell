$regex = "^( +)"
get-childitem -R *.* | foreach { rename-item $_ ($_.Name -Replace $regex,'_') }