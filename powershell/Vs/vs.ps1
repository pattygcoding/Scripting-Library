function vs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$FileName,
        [Parameter()]
        [string]$IndexFile = '' # Insert cache location here
    )

    if (-not $FileName) {
        Write-Error "Please provide a file name."
        return
    }
    $base = [IO.Path]::GetFileNameWithoutExtension($FileName)
    $searchFile = if ([IO.Path]::GetExtension($FileName)) { $FileName } else { "$base.cs" }

    if (Test-Path $IndexFile) {
        if (-not $Global:VsIndex) {
            $Global:VsIndex = @{}
            Get-Content $IndexFile | ForEach-Object {
                if ($_ -match '^(.*?)\|(.*)$') {
                    $k = $matches[1]
                    $dirs = $matches[2].Split(';') | Where-Object { $_ -ne '' }
                    $Global:VsIndex[$k] = $dirs
                }
            }
        }

        if ($Global:VsIndex.ContainsKey($base)) {
            $paths = $Global:VsIndex[$base] | ForEach-Object { Join-Path $_ $searchFile }
            $existing = $paths | Where-Object { Test-Path $_ }
            if ($existing) {
                try {
                    $dte = [Runtime.InteropServices.Marshal]::GetActiveObject('VisualStudio.DTE.17.0')
                    $existing | ForEach-Object { $dte.ItemOperations.OpenFile($_) }
                } catch {
                    & 'devenv.exe' /Edit @($existing)
                }
                $existing | ForEach-Object { Write-Host "Opened (cache): $_" -ForegroundColor Yellow }
                return
            }
        }
    }

    $excludes = 'bin','obj','.git','node_modules'
    $matches = [IO.Directory]::EnumerateFiles($PWD, $searchFile, 'AllDirectories') |
        Where-Object {
            $full = $_.Replace('/', '\')
            foreach ($bad in $excludes) {
                if ($full -match "\\$bad\\") { return $false }
            }
            return $true
        } |
        Select-Object -Unique

    if (-not $matches) {
        Write-Error "No instances of '$searchFile' found under '$PWD'."
        return
    }

    try {
        $dte = [Runtime.InteropServices.Marshal]::GetActiveObject('VisualStudio.DTE.17.0')
        $matches | ForEach-Object { $dte.ItemOperations.OpenFile($_) }
    } catch {
        & 'devenv.exe' /Edit @($matches)
    }
    $matches | ForEach-Object { Write-Host "Opened (fs): $_" -ForegroundColor Yellow }
}
