<#
.SYNOPSIS
    Summarizes DbCommands, actions, action methods, and endpoints from a .NET log.

.DESCRIPTION
    Parses a captured .NET (ASP.NET Core) console log and prints four grouped
    sections with their source line numbers: executed DbCommands (with the
    database and joined tables), executed action methods, executed actions, and
    executed endpoints. Framework noise is left out of the DbCommand lines.

.PARAMETER f
    The log file to analyze. Defaults to "TestFile1.txt".

.EXAMPLE
    dotnet-analysis -f "log.txt"
#>
function dotnet-analysis {
    [CmdletBinding()]
    param (
        [string]$f = 'TestFile1.txt'
    )

    function Process-DbCommandBlock {
        param (
            [string]$dbCommand,
            [int]$lineStart
        )

        # Extract the database name from a FROM or UPDATE clause.
        $dbName = if ($dbCommand -match 'FROM \[(\w+)\]') {
            $matches[1]
        }
        elseif ($dbCommand -match 'UPDATE \[(\w+)\]') {
            $matches[1]
        }
        else {
            'Unknown DB'
        }

        # Extract every JOINed table in one pass.
        $joins = [regex]::Matches($dbCommand, 'JOIN \[(\w+)\]') | ForEach-Object { $_.Groups[1].Value }

        if ($joins.Count -gt 0) {
            $joinString = $joins -join ', '
            return "$lineStart [INF] Executed DbCommand from DB [$dbName] with joins: [$joinString]"
        }
        else {
            return "$lineStart [INF] Executed DbCommand from DB [$dbName]"
        }
    }

    function Group-DbCommandLines {
        param (
            [array]$dbCommandLines
        )

        $groupedLines = @()
        $previousDbInfo = ''
        $currentGroup = ''

        foreach ($line in $dbCommandLines) {
            $lineParts = $line -split '\s', 2
            $lineNumber = $lineParts[0]
            $dbInfo = $lineParts[1]

            if ($dbInfo -eq $previousDbInfo) {
                $currentGroup += ", $lineNumber"
            }
            else {
                if ($currentGroup) {
                    $groupedLines += "$currentGroup $previousDbInfo"
                }
                $currentGroup = $lineNumber
                $previousDbInfo = $dbInfo
            }
        }

        # Add the last group.
        if ($currentGroup) {
            $groupedLines += "$currentGroup $previousDbInfo"
        }

        return $groupedLines
    }

    if (-not (Test-Path $f)) {
        Write-Host "File not found: $f" -ForegroundColor Red
        return
    }

    $lineNumber = 1
    $actionMethodLines = @()
    $actionLines = @()
    $endpointLines = @()
    $dbCommandLines = @()

    $currentDbCommand = ''
    $currentLineStart = $null

    # Read and categorize the lines, keeping their line numbers.
    Get-Content $f | ForEach-Object {
        if ($_ -match 'Executed action method') {
            $actionMethodLines += "$lineNumber $_"
        }
        elseif ($_ -match 'Executed action') {
            $actionLines += "$lineNumber $_"
        }
        elseif ($_ -match 'Executed endpoint') {
            $endpointLines += "$lineNumber $_"
        }
        elseif ($_ -match 'Executed DbCommand') {
            # A new DB command block starts; flush the previous one first.
            if ($currentDbCommand) {
                $dbCommandLines += Process-DbCommandBlock -dbCommand $currentDbCommand -lineStart $currentLineStart
            }
            $currentDbCommand = $_
            $currentLineStart = $lineNumber
        }
        elseif ($currentDbCommand) {
            # Keep collecting lines that belong to the current DB command.
            $currentDbCommand += "`n$_"
        }
        $lineNumber++
    }

    # Flush the final DB command block.
    if ($currentDbCommand) {
        $dbCommandLines += Process-DbCommandBlock -dbCommand $currentDbCommand -lineStart $currentLineStart
    }

    # Sort each section by its leading line number.
    $actionMethodLines = $actionMethodLines | Sort-Object { [int]($_ -split ' ')[0] }
    $actionLines = $actionLines | Sort-Object { [int]($_ -split ' ')[0] }
    $endpointLines = $endpointLines | Sort-Object { [int]($_ -split ' ')[0] }
    $dbCommandLines = $dbCommandLines | Sort-Object { [int]($_ -split ' ')[0] }

    $groupedDbCommandLines = Group-DbCommandLines $dbCommandLines

    Write-Host "`n--- Executed DbCommands ---" -ForegroundColor Cyan
    $groupedDbCommandLines | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }

    Write-Host "`n--- Executed Action Methods ---" -ForegroundColor Cyan
    $actionMethodLines | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }

    Write-Host "`n--- Executed Actions ---" -ForegroundColor Cyan
    $actionLines | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }

    Write-Host "`n--- Executed Endpoints ---" -ForegroundColor Cyan
    $endpointLines | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }
}
