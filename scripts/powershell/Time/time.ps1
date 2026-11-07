<#
.SYNOPSIS
    Measures how long an operation takes.

.DESCRIPTION
    Runs the supplied script block and prints the elapsed time in seconds.

.PARAMETER f
    The script block (operation) to measure. Required.

.EXAMPLE
    time -f { Write-Output "Hello World" }
#>
function time {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]$f
    )

    $executionTime = Measure-Command { & $f }
    Write-Host "`nThe task took $($executionTime.TotalSeconds) seconds to complete.`n" -ForegroundColor Magenta
}
