function Clear-Downloads {
    $downloads = "C:\Users\patty\Downloads"
    if (Test-Path $downloads) {
        Write-Host "Deleting all contents in $downloads..." -ForegroundColor Yellow
        Get-ChildItem -Path $downloads -Recurse -Force | Remove-Item -Recurse -Force
        Write-Host "Downloads folder cleared permanently." -ForegroundColor Green
    } else {
        Write-Host "Downloads folder not found: $downloads" -ForegroundColor Red
    }
}
