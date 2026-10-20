function safe-unzip {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]$ZipPath,

        [Parameter(Position=1)]
        [int]$MAX_FILE_COUNT = 1000,

        [Parameter(Position=2)]
        [long]$MAX_TOTAL_SIZE_BYTES = 524288000
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    if (-not (Test-Path $ZipPath)) {
        Write-Error "Zip file not found: $ZipPath"
        return
    }

    $DestinationPath = Join-Path -Path (Split-Path -Parent $ZipPath) -ChildPath ([IO.Path]::GetFileNameWithoutExtension($ZipPath) + "_unzipped")
    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null

    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($ZipPath)
        $entryCount = 0
        $totalSize = 0

        foreach ($entry in $zip.Entries) {
            if ($entry.FullName -match '(^\.\.|[\\/]\.\.[\\/]|^\s*$)') {
                throw "Aborted: Unsafe path detected in entry '$($entry.FullName)'"
            }

            if ($entry.Length -gt 0) {
                $entryCount++
                $totalSize += $entry.Length

                if ($entryCount -gt $MAX_FILE_COUNT) {
                    throw "Aborted: File count exceeds $MAX_FILE_COUNT."
                }

                if ($totalSize -gt $MAX_TOTAL_SIZE_BYTES) {
                    throw "Aborted: Total size exceeds $($MAX_TOTAL_SIZE_BYTES / 1MB) MB."
                }
            }
        }

        [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $DestinationPath)
        Write-Host "Extracted to: $DestinationPath"
    }
    catch {
        Write-Error "Extraction failed: $_"
    }
}
