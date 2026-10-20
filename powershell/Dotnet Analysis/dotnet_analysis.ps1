function dotnet-analysis {
    param (
        [string]$f = "TestFile1.txt"
    )
	
    function Process-DbCommandBlock {
        param (
            [string]$dbCommand,
            [int]$lineStart
        )

        # Extract database name from FROM or UPDATE clause
        $dbName = if ($dbCommand -match "FROM \[(\w+)\]") {
            $matches[1]
        } elseif ($dbCommand -match "UPDATE \[(\w+)\]") {
            $matches[1]
        } else {
            "Unknown DB"
        }

        # Extract all JOINed tables in one go using regex
        $joins = [regex]::Matches($dbCommand, "JOIN \[(\w+)\]") | ForEach-Object { $_.Groups[1].Value }

        # Format output without printing the full SQL query and cut off after "DbCommand"
        if ($joins.Count -gt 0) {
            $joinString = $joins -join ", "
            return "$lineStart [INF] Executed DbCommand from DB [$dbName] with joins: [$joinString]"
        } else {
            return "$lineStart [INF] Executed DbCommand from DB [$dbName]"
        }
    }

    function Group-DbCommandLines {
        param (
            [array]$dbCommandLines
        )

        $groupedLines = @()
        $previousDbInfo = ""
        $currentGroup = ""

        foreach ($line in $dbCommandLines) {
            $lineParts = $line -split '\s', 2
            $lineNumber = $lineParts[0]
            $dbInfo = $lineParts[1]

            if ($dbInfo -eq $previousDbInfo) {
                $currentGroup += ", $lineNumber"
            } else {
                if ($currentGroup) {
                    $groupedLines += "$currentGroup $previousDbInfo"
                }
                $currentGroup = $lineNumber
                $previousDbInfo = $dbInfo
            }
        }

        # Add the last group
        if ($currentGroup) {
            $groupedLines += "$currentGroup $previousDbInfo"
        }

        return $groupedLines
    }

    if (Test-Path $f) {
        $lineNumber = 1
        $actionMethodLines = @()
        $actionLines = @()
        $endpointLines = @()
        $dbCommandLines = @()

        $currentDbCommand = ""
        $currentLineStart = $null

        # Read and categorize the lines with line numbers
        Get-Content $f | ForEach-Object {
            if ($_ -match "Executed action method") {
                $actionMethodLines += "$lineNumber $_"
            } elseif ($_ -match "Executed action") {
                $actionLines += "$lineNumber $_"
            } elseif ($_ -match "Executed endpoint") {
                $endpointLines += "$lineNumber $_"
            } elseif ($_ -match "Executed DbCommand") {
                # Starting a new DB command block
                if ($currentDbCommand) {
                    # Process the previous DB command block before starting a new one
                    $dbCommandLines += Process-DbCommandBlock -dbCommand $currentDbCommand -lineStart $currentLineStart
                }
                $currentDbCommand = $_
                $currentLineStart = $lineNumber
            } elseif ($currentDbCommand) {
                # Continue collecting lines that belong to the current DB command
                $currentDbCommand += "`n$_"
            }
            $lineNumber++
        }

        # Process the last DB command block
        if ($currentDbCommand) {
            $dbCommandLines += Process-DbCommandBlock -dbCommand $currentDbCommand -lineStart $currentLineStart
        }

        # Sort by the first number in the line numerically
        $actionMethodLines = $actionMethodLines | Sort-Object { [int]($_ -split ' ')[0] }
        $actionLines = $actionLines | Sort-Object { [int]($_ -split ' ')[0] }
        $endpointLines = $endpointLines | Sort-Object { [int]($_ -split ' ')[0] }
        $dbCommandLines = $dbCommandLines | Sort-Object { [int]($_ -split ' ')[0] }

        # Group consecutive DbCommand lines
        $groupedDbCommandLines = Group-DbCommandLines $dbCommandLines
		
		# Section for "Executed DbCommands"
        Write-Host "`n--- Executed DbCommands ---" -ForegroundColor Cyan
        $groupedDbCommandLines | ForEach-Object {
            Write-Host $_ -ForegroundColor Yellow
        }

        # Section for "Executed Action Methods"
        Write-Host "`n--- Executed Action Methods ---" -ForegroundColor Cyan
        $actionMethodLines | ForEach-Object {
            Write-Host $_ -ForegroundColor Yellow
        }

        # Section for "Executed Actions"
        Write-Host "`n--- Executed Actions ---" -ForegroundColor Cyan
        $actionLines | ForEach-Object {
            Write-Host $_ -ForegroundColor Yellow
        }

        # Section for "Executed Endpoints"
        Write-Host "`n--- Executed Endpoints ---" -ForegroundColor Cyan
        $endpointLines | ForEach-Object {
            Write-Host $_ -ForegroundColor Yellow
        }
    } else {
        Write-Host "File not found: $f" -ForegroundColor Red
    }
}
