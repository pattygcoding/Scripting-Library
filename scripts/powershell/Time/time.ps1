function time {
    param (
        [Parameter(Mandatory=$true)]
        [ScriptBlock]$f
    )

    $executionTime = Measure-Command { &$f }
    Write-Host "`nThe task took $($executionTime.TotalSeconds) seconds to complete.`n" -ForegroundColor Magenta
}
