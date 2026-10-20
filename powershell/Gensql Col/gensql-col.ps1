function gensql-col {
	# Example: gensql-findcol -c "State"
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$c
    )
    
    $script = @"
WITH ColumnEntries AS (
    SELECT
        C.TABLE_SCHEMA,
        C.TABLE_NAME,
        C.COLUMN_NAME,
        COUNT(*) AS EntryCount
    FROM
        INFORMATION_SCHEMA.COLUMNS C
    JOIN
        INFORMATION_SCHEMA.TABLES T
    ON 
        C.TABLE_NAME = T.TABLE_NAME 
        AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
    WHERE
        C.COLUMN_NAME LIKE '%$c%'
        AND T.TABLE_TYPE = 'BASE TABLE'
    GROUP BY
        C.TABLE_SCHEMA, C.TABLE_NAME, C.COLUMN_NAME
)
SELECT
    C.TABLE_SCHEMA AS SchemaName,
    C.TABLE_NAME AS TableName,
    C.COLUMN_NAME AS ColumnName,
    CASE 
        WHEN E.EntryCount > 0 THEN 'True'
        ELSE 'False'
    END AS HasEntries
FROM
    INFORMATION_SCHEMA.COLUMNS C
LEFT JOIN 
    ColumnEntries E
ON 
    C.TABLE_SCHEMA = E.TABLE_SCHEMA 
    AND C.TABLE_NAME = E.TABLE_NAME 
    AND C.COLUMN_NAME = E.COLUMN_NAME
WHERE
    C.COLUMN_NAME LIKE '%$c%'
ORDER BY
    SchemaName;

"@

    Write-Host $script -ForegroundColor Magenta
}
