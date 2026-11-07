<#
.SYNOPSIS
    Finds a file by name and opens it in Visual Studio Code.

.DESCRIPTION
    Searches the current directory tree for files matching the given name and
    opens each match in VS Code.

.PARAMETER f
    The name of the file to search for. Required.

.EXAMPLE
    vsc -f "example.js"
#>
function vsc {
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
        Write-Host "PowerShell (vsc): Opening file in Visual Studio Code: $file" -ForegroundColor Yellow
        & 'code' $file
    }
}
