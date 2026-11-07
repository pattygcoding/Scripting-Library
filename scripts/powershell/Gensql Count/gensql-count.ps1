<#
.SYNOPSIS
    Generates a SQL script to count the entries in a table.

.DESCRIPTION
    Prints a T-SQL query that returns the number of rows in the given table.

.PARAMETER t
    The table name (optionally schema-qualified). Required.

.EXAMPLE
    gensql-count -t "[db].[Table]"
#>
function gensql-count {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$t
    )

    $script = @"
SELECT COUNT(*) AS total_entries
FROM $t;

"@

    Write-Host $script -ForegroundColor Magenta
}
