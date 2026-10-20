function stack-trace {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string] $Path = "test.txt"
    )

    if (-not (Test-Path $Path)) {
        Write-Error "File not found: $Path"
        return
    }

    $raw = Get-Content -Path $Path -Raw
    $frames = [regex]::Split($raw, '(?=\bat\s)')

    foreach ($f in $frames) {
        if ($f -match '^at ' -and $f -notmatch '^at Microsoft') {
            if ($f -match ' in (.+)$') {
                $rel = (
                    (
                        $Matches[1] `
                        -replace '[\\]+','/' `
                        -replace '/{2,}','/' `
                        -replace '(?i)^[A-Za-z]:/a/1/s/',''
                    ) -replace '/r/n',''
                ).Trim()

                Write-Host $rel -ForegroundColor Yellow
            }
        }
    }
}
