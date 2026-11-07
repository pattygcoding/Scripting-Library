-- Generates a SQL script to search for a column name across a database.

local MAGENTA = "\27[35m"
local RESET = "\27[0m"

local TEMPLATE = [[
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
        C.COLUMN_NAME LIKE '%__COLUMN__%'
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
    C.COLUMN_NAME LIKE '%__COLUMN__%'
ORDER BY
    SchemaName;
]]

local function main()
  local column
  local i = 1
  while i <= #arg do
    if arg[i] == "-c" or arg[i] == "--column" then
      column = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  if not column then
    io.stderr:write("Error: -c/--column is required.\n")
    os.exit(1)
  end

  local sql = TEMPLATE:gsub("__COLUMN__", column)
  print(MAGENTA .. sql .. RESET)
end

main()
