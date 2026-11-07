<#
.SYNOPSIS
    Safely extracts a ZIP archive with zip-bomb and traversal protections.

.DESCRIPTION
    Validates a ZIP file before extracting it: rejects entries with unsafe
    (path-traversal) names and aborts if the file count or total uncompressed
    size exceeds the configured limits. Extracts to a sibling folder named after
    the archive with a "_unzipped" suffix.

.PARAMETER ZipPath
    Path to the ZIP file to extract. Required.

.PARAMETER MAX_FILE_COUNT
    Maximum number of files allowed. Defaults to 1000.

.PARAMETER MAX_TOTAL_SIZE_BYTES
    Maximum total uncompressed size in bytes. Defaults to 500 MB.

.EXAMPLE
    safe-unzip "archive.zip"
    safe-unzip "archive.zip" -MAX_FILE_COUNT 500 -MAX_TOTAL_SIZE_BYTES 104857600
#>
function safe-unzip {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$ZipPath,

        [Parameter(Position = 1)]
        [int]$MAX_FILE_COUNT = 1000,

        [Parameter(Position = 2)]
        [long]$MAX_TOTAL_SIZE_BYTES = 524288000
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    if (-not (Test-Path $ZipPath)) {
        Write-Error "Zip file not found: $ZipPath"
        return
    }

    $DestinationPath = Join-Path -Path (Split-Path -Parent $ZipPath) -ChildPath ([IO.Path]::GetFileNameWithoutExtension($ZipPath) + '_unzipped')
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
    finally {
        if ($zip) { $zip.Dispose() }
    }
}
