<#
.SYNOPSIS
    Clears the current user's Downloads folder.

.DESCRIPTION
    Permanently deletes every file and folder inside the Downloads directory.
    This is destructive and cannot be undone.

.EXAMPLE
    Clear-Downloads
#>
function Clear-Downloads {
    [CmdletBinding()]
    param ()

    $downloads = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'

    if (Test-Path $downloads) {
        Write-Host "Deleting all contents in $downloads..." -ForegroundColor Yellow
        Get-ChildItem -Path $downloads -Recurse -Force | Remove-Item -Recurse -Force
        Write-Host 'Downloads folder cleared permanently.' -ForegroundColor Green
    }
    else {
        Write-Host "Downloads folder not found: $downloads" -ForegroundColor Red
    }
}
