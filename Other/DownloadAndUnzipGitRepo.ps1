# Function to download and unzip a GitHub repository
function DownloadAndUnzipRepository($url, $outputDir) {
    # Extract the repository name from the URL
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($url.Split('/')[-1])

    # Create the output directory if it doesn't exist
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    }

    # Download the zip file
    $zipFilePath = Join-Path -Path $outputDir -ChildPath "$repoName.zip"
    Invoke-WebRequest -Uri $url -OutFile $zipFilePath

    # Unzip the file
    Expand-Archive -Path $zipFilePath -DestinationPath $outputDir

    # Remove the zip file
    Remove-Item -Path $zipFilePath

    # Remove non-Markdown files
    $markdownFiles = Get-ChildItem -Path $outputDir -Filter "*.md" -Recurse
    $nonMarkdownFiles = Get-ChildItem -Path $outputDir -Exclude $markdownFiles -Recurse
    $nonMarkdownFiles | Remove-Item -Force -Recurse
}

# URLs of the GitHub repositories
$repo1Url = "https://github.com/MicrosoftDocs/azure-docs/archive/master.zip"
$repo2Url = "https://github.com/MicrosoftDocs/architecture-center/archive/master.zip"

# Output directories for the repositories
$outputDir1 = "./repo1"
$outputDir2 = "./repo2"

# Download and unzip the repositories
DownloadAndUnzipRepository -url $repo1Url -outputDir $outputDir1
DownloadAndUnzipRepository -url $repo2Url -outputDir $outputDir2

Write-Host "Repositories downloaded and unzipped successfully!"
