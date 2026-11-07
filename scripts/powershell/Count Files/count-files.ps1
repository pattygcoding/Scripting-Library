<#
.SYNOPSIS
    Counts files in the current directory tree, grouped by extension.

.DESCRIPTION
    Recursively counts every file under the current directory and prints the
    total plus a breakdown by file extension. Files inside node_modules are
    excluded unless -includenode is specified.

.PARAMETER includenode
    Switch. Include files inside node_modules directories.

.EXAMPLE
    count-files
    count-files -includenode
#>
function count-files {
    [CmdletBinding()]
    param (
        [switch]$includenode
    )

    $directory = Get-Location
    $files = Get-ChildItem -Path $directory -Recurse -File

    if (-not $includenode) {
        $files = $files | Where-Object { $_.FullName -notlike '*\node_modules\*' }
    }

    $totalFiles = $files.Count
    $filesByExtension = $files | Group-Object -Property Extension | Sort-Object Name

    Write-Host 'Total number of files: ' -ForegroundColor Cyan -NoNewline
    Write-Host "$totalFiles" -ForegroundColor Yellow
    Write-Host 'Files by extension:' -ForegroundColor Cyan
    foreach ($group in $filesByExtension) {
        Write-Host ('{0}: {1}' -f $group.Name, $group.Count) -ForegroundColor Yellow
    }
}
