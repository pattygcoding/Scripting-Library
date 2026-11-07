<#
.SYNOPSIS
    Compares two files line by line and highlights the differences.

.DESCRIPTION
    Reads two text files and reports the lines that differ. Lines only in the
    first file are shown in red; lines only in the second file are shown in
    green. Optionally ignores log timestamps during the comparison.

.PARAMETER f1
    The first file to compare. Defaults to "TestFile1.txt".

.PARAMETER f2
    The second file to compare. Defaults to "TestFile2.txt".

.PARAMETER notime
    Switch. When set, timestamps and duration markers are stripped before
    comparing so only the meaningful content is diffed.

.EXAMPLE
    compare-diff -f1 "File1.txt" -f2 "File2.txt" -notime
#>
function compare-diff {
    [CmdletBinding()]
    param (
        [string]$f1 = 'TestFile1.txt',
        [string]$f2 = 'TestFile2.txt',
        [switch]$notime
    )

    Write-Host "`nRED = $f1" -ForegroundColor Red
    Write-Host "GREEN = $f2`n" -ForegroundColor Green

    # Strips log timestamps and "(123ms)" style durations from a set of lines.
    function Remove-Timestamps {
        param (
            [string[]]$lines
        )
        $pattern = '\[\d{2}:\d{2}:\d{2}\s\w{3}\]|\(\d+ms\)'
        return $lines -replace $pattern, ''
    }

    $content1 = Get-Content -Path $f1
    $content2 = Get-Content -Path $f2

    if ($notime) {
        Write-Host 'Please note that since you included the -notime flag, timestamps will not be compared or displayed.' -ForegroundColor Yellow
        $content1 = Remove-Timestamps -lines $content1
        $content2 = Remove-Timestamps -lines $content2
    }

    $differences = Compare-Object -ReferenceObject $content1 -DifferenceObject $content2

    foreach ($difference in $differences) {
        if ($difference.SideIndicator -eq '<=') {
            Write-Host "- $($difference.InputObject)" -ForegroundColor Red
        }
        elseif ($difference.SideIndicator -eq '=>') {
            Write-Host "+ $($difference.InputObject)" -ForegroundColor Green
        }
    }
}
