# Obtain SQL
Obtains the SQL format for a header and value row.

## Parameters
- `headerRow`: The number of the first row to compare.
- `valueRow`: The number of the second row to compare.
- `sheet`: the name of the sheet (defualt: your current sheet)

## Examples:
```
=obtainSQL(2, 3)
=obtainSQL(2, 3, "Sheet2")
```
