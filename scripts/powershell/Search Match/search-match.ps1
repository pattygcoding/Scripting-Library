<#
.SYNOPSIS
    Searches files of a given extension for one or more strings.

.DESCRIPTION
    Recursively scans files matching the given extension in the current
    directory and prints each matching line with its line number. Supports a
    result cap, cross-term (AND) matching, full-path output, and filtering to
    method-call usages.

.PARAMETER e
    The file extension to search (with or without the leading dot).

.PARAMETER s
    One or more strings to search for within the files.

.PARAMETER uncapped
    Switch. List more than the default 3000 results.

.PARAMETER cross
    Switch. Only report files that contain all of the given strings.

.PARAMETER dir
    Switch. Display full file paths instead of file names only.

.PARAMETER calls
    Switch. Only match the string when preceded by a period, e.g. a method call.

.EXAMPLE
    search-match -e ".cs" -s "SearchTerm1", "SearchTerm2" -cross -dir
#>
function search-match {
    [CmdletBinding()]
    param (
        [string]$e,
        [string[]]$s,
        [switch]$uncapped,
        [switch]$cross,
        [switch]$dir,
        [switch]$calls
    )

    # Ensure the extension starts with a dot.
    if (-not $e.StartsWith('.')) {
        $e = ".$e"
    }

    $maxResults = 3000
    $resultsCount = 0
    $resultsCapReached = $false

    try {
        $files = @([System.IO.Directory]::EnumerateFiles((Get-Location), "*$e", [System.IO.SearchOption]::AllDirectories))

        foreach ($file in $files) {
            if ($resultsCapReached) { break }

            $lines = Get-Content -Path $file
            $printedFileName = $false
            $skipUsingDirectives = $e -eq '.cs'
            $searchActive = -not $skipUsingDirectives
            $lineNumber = 0

            $termMatches = @{}

            foreach ($line in $lines) {
                $lineNumber++

                # Skip leading "using" directives for .cs files.
                if ($skipUsingDirectives -and $line.TrimStart().StartsWith('using ')) {
                    continue
                }

                # The first non-"using" line activates the search.
                if ($skipUsingDirectives -and -not $line.TrimStart().StartsWith('using ')) {
                    $searchActive = $true
                    $skipUsingDirectives = $false
                }

                if ($searchActive) {
                    foreach ($searchTerm in $s) {
                        $escapedTerm = [regex]::Escape($searchTerm)

                        if ($cross) {
                            if ($line -match $escapedTerm) {
                                if (-not $termMatches.ContainsKey($searchTerm)) {
                                    $termMatches[$searchTerm] = @()
                                }
                                $termMatches[$searchTerm] += $lineNumber
                            }
                        }
                        else {
                            # Require a leading '.' when -calls is set.
                            if ($line -match $escapedTerm -and (-not $calls -or $line -match "\.$escapedTerm")) {
                                if (-not $printedFileName) {
                                    if ($dir) {
                                        Write-Output "$file"
                                    }
                                    else {
                                        $fileName = [System.IO.Path]::GetFileName($file)
                                        Write-Output $fileName
                                    }
                                    $printedFileName = $true
                                }

                                $trimmedLine = $line.TrimStart()
                                $formattedLine = "$lineNumber`t`t$trimmedLine"
                                Write-Output $formattedLine

                                $resultsCount++
                                if (-not $uncapped -and $resultsCount -ge $maxResults) {
                                    $resultsCapReached = $true
                                    break
                                }
                            }
                        }

                        if ($resultsCapReached) { break }
                    }
                }
            }

            if ($cross -and $termMatches.Count -eq $s.Length) {
                if ($dir) {
                    Write-Output "$file"
                }
                else {
                    $fileName = [System.IO.Path]::GetFileName($file)
                    Write-Output $fileName
                }

                foreach ($searchTerm in $termMatches.Keys) {
                    foreach ($lineNum in $termMatches[$searchTerm]) {
                        $lineContent = $lines[$lineNum - 1].TrimStart()
                        Write-Output "$lineNum`t`t$lineContent"
                    }
                }

                $resultsCount++
                if (-not $uncapped -and $resultsCount -ge $maxResults) {
                    $resultsCapReached = $true
                    break
                }
            }
        }
    }
    catch {
        Write-Error "An error occurred while searching for files: $_"
    }
}
