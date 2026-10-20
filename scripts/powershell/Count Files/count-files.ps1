function count-files {
    param (
        [switch]$includenode
    )

    $directory = Get-Location
    # Get all files recursively
    $files = Get-ChildItem -Path $directory -Recurse -File

    # Filter out files in node_modules unless includenode switch is provided
    if (-not $includenode) {
        $files = $files | Where-Object { $_.FullName -notlike "*\node_modules\*" }
    }

    $totalFiles = $files.Count
    $filesByExtension = $files | Group-Object -Property Extension | Sort-Object Name
    
    Write-Host "Total number of files: " -ForegroundColor Cyan -NoNewline
    Write-Host "$totalFiles" -ForegroundColor Yellow
    Write-Host "Files by extension:" -ForegroundColor Cyan
    foreach ($group in $filesByExtension) {
        Write-Host ("{0}: {1}" -f $group.Name, $group.Count) -ForegroundColor Yellow
    }
}
