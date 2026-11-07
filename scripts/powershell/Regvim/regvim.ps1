<#
.SYNOPSIS
    Opens every matching file in Vim.

.DESCRIPTION
    Searches the current directory tree for files matching the given name and
    opens each match in Vim.

.PARAMETER f
    The file name to search for. Required.

.EXAMPLE
    regvim -f "example.txt"
#>
function regvim {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$f
    )

    if ([string]::IsNullOrEmpty($f)) {
        Write-Error 'Please provide a file name to search for.'
        return
    }

    $currentDirectory = Get-Location
    $files = @([System.IO.Directory]::EnumerateFiles($currentDirectory, $f, [System.IO.SearchOption]::AllDirectories))

    if ($files.Count -eq 0) {
        Write-Error "No instances of '$f' found in subdirectories."
        return
    }

    foreach ($file in $files) {
        Write-Host "PowerShell (regvim): Opening file in vim: $file" -ForegroundColor Yellow
        & 'vim' $file
    }
}
