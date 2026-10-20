# Compare Rows
Compares 2 rows and returns the differences.

## Parameters
- `row1`: The number of the first row to compare.
- `row2`: The number of the second row to compare.
- `sheet`: the name of the sheet (defualt: your current sheet)
- `includeTimestamps`: Displays timestamp differences if TRUE

## Examples:
```
=compareRows(2, 3)
=compareRows(2, 3, "Sheet2")
=compareRows(2, 3, , TRUE)
=compareRows(2, 3, "Sheet2", TRUE)
```
