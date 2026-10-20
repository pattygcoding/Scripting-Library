function neovim {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$f 
    )
    if ([string]::IsNullOrEmpty($f)) {
        Write-Error "Please provide a file name to search for."
        return
    }
    $currentDirectory = Get-Location
    $files = [System.IO.Directory]::EnumerateFiles($currentDirectory, $f, [System.IO.SearchOption]::AllDirectories) | ForEach-Object { $_ }
    if ($files.Count -eq 0) {
        Write-Error "No instances of '$f' found in subdirectories."
        return
    }
    foreach ($file in $files) {
        Write-Host("PowerShell (neovim): Opening file in neovim: $file") -ForegroundColor Yellow
        & "nvim" $file
    }
}
