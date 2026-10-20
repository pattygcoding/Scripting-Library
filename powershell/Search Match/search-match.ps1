function search-match {
    # -uncapped: List more than the limit 3000 results
    # -cross: Only search for files that have all of the strings, not just any
    # -dir: Display the full file directories, not just the file names
    # -calls: Display only if there is a period (.) before the string. Useful for locating function calls

    param(
        [string]$e,
        [string[]]$s,  # Accept an array of strings
        [switch]$uncapped,
        [switch]$cross,
        [switch]$dir,
        [switch]$calls # New parameter for filtering based on method call pattern
    )

    # Ensure the extension starts with a dot
    if (-not $e.StartsWith(".")) {
        $e = ".$e"
    }

    $maxResults = 3000
    $resultsCount = 0
    $resultsCapReached = $false

    # Use .NET methods to enumerate files with the specified extension in the current directory and subdirectories
    try {
        $files = [System.IO.Directory]::EnumerateFiles((Get-Location), "*$e", [System.IO.SearchOption]::AllDirectories) | ForEach-Object { $_ }

        foreach ($file in $files) {
            if ($resultsCapReached) { break }

            $lines = Get-Content -Path $file
            $printedFileName = $false
            $skipUsingDirectives = $e -eq ".cs"
            $searchActive = -not $skipUsingDirectives
            $lineNumber = 0

            $termMatches = @{} # A hashtable to track if all terms are found in the file

            foreach ($line in $lines) {
                $lineNumber++

                # Skip lines that start with "using" for .cs files
                if ($skipUsingDirectives -and $line.TrimStart().StartsWith("using ")) {
                    continue
                }

                # Once a non-"using" line is found, activate search and stop skipping
                if ($skipUsingDirectives -and -not $line.TrimStart().StartsWith("using ")) {
                    $searchActive = $true
                    $skipUsingDirectives = $false
                }

                if ($searchActive) {
                    foreach ($searchTerm in $s) {
                        $escapedTerm = [regex]::Escape($searchTerm)

                        # Handle the cross search logic
                        if ($cross) {
                            if ($line -match $escapedTerm) {
                                if (-not $termMatches.ContainsKey($searchTerm)) {
                                    $termMatches[$searchTerm] = @()
                                }
                                $termMatches[$searchTerm] += $lineNumber
                            }
                        }
                        else {
                            # Check for the presence of '.' before the term if -calls is specified
                            if ($line -match $escapedTerm -and (-not $calls -or $line -match "\.$escapedTerm")) {
                                # Print the file name once if not already printed
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

                                # Prepare the formatted line output
                                $trimmedLine = $line.TrimStart() # Remove leading whitespace
                                $formattedLine = "$lineNumber`t`t$trimmedLine" # Add line number and a tab at the beginning
                                Write-Output $formattedLine

                                # Count and check results limit
                                $resultsCount++
                                if (-not $uncapped -and $resultsCount -ge $maxResults) {
                                    $resultsCapReached = $true
                                    break
                                }
                            }
                        }

                        # Exit the outer loop if the results cap is reached
                        if ($resultsCapReached) { break }
                    }
                }
            }
            if ($termMatches.Count -eq $s.Length -and $cross) {
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
    } catch {
        Write-Error "An error occurred while searching for files: $_"
    }
}
