<#
.SYNOPSIS
    Builds and updates an index of .cs files under a directory tree.

.DESCRIPTION
    Scans a root directory for .cs files and maintains a text index that maps
    each file's base name to the directories that contain it. Reports which
    entries were added, removed, or changed since the index was last written.

.PARAMETER Root
    The root directory to scan. Defaults to the current location.

.PARAMETER IndexFile
    Path to the index file to create or update. Required.

.EXAMPLE
    cache-vsindex -Root "C:\MyProject" -IndexFile "index.txt"
#>
function cache-vsindex {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$Root = (Get-Location),

        [Parameter(Position = 1)]
        [string]$IndexFile = '' # Insert your index file path here
    )

    $oldMap = @{}
    if (Test-Path $IndexFile) {
        Get-Content $IndexFile | ForEach-Object {
            if ($_ -match '^(.*?)\|(.*)$') {
                $oldMap[$matches[1]] = $matches[2].Split(';')
            }
        }
    }

    $newMap = @{}
    Get-ChildItem -Path $Root -Filter *.cs -Recurse -File | ForEach-Object {
        $key = $_.BaseName
        if (-not $newMap.ContainsKey($key)) {
            $newMap[$key] = [System.Collections.Generic.List[string]]::new()
        }
        $newMap[$key].Add($_.DirectoryName)
    }

    $allKeys = @($newMap.Keys)
    foreach ($k in $allKeys) {
        $newMap[$k] = $newMap[$k] | Sort-Object -Unique
    }

    $added   = $newMap.Keys | Where-Object { -not $oldMap.ContainsKey($_) }
    $removed = $oldMap.Keys | Where-Object { -not $newMap.ContainsKey($_) }
    $changed = $newMap.Keys | Where-Object {
        $oldMap.ContainsKey($_) -and
        (Compare-Object -ReferenceObject $oldMap[$_] `
                        -DifferenceObject $newMap[$_] `
                        -SyncWindow 0).Count -gt 0
    }

    if (($added.Count + $removed.Count + $changed.Count) -eq 0) {
        Write-Host "No changes detected in .cs files under '$Root'." -ForegroundColor Green
        return
    }

    $lines = @()
    if (Test-Path $IndexFile) {
        $lines = Get-Content $IndexFile
    }

    $keysToDelete = $removed + $changed
    if ($keysToDelete) {
        $pattern = '^(' + ($keysToDelete -join '|') + ')\|'
        $lines = $lines | Where-Object { $_ -notmatch $pattern }
    }

    $newLines = foreach ($key in ($added + $changed | Sort-Object)) {
        "$key|$($newMap[$key] -join ';')"
    }

    $final = ($lines + $newLines) |
             Sort-Object { $_.Split('|')[0] }

    Set-Content -Path $IndexFile -Value $final -Encoding UTF8

    Write-Host "Index updated: +$($added.Count) / -$($removed.Count) / *$($changed.Count)" -ForegroundColor Cyan
}
