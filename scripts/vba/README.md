# Spreadsheet Scripts by Patrick Goodwin
A collection of spreadsheet scripts for Excel and Google Sheets, written to compare and clean SQL output without leaving the grid. Each script ships in all three formats and lives in its own folder with a README.

## Programming Languages Used
- **VBA** — Microsoft Visual Basic for Applications (the `.vba` files).
- **Google Apps Script** — a superset of JavaScript (the `.gs` files).
- **Office Script** — a superset of TypeScript (the `.ts` files). Experimental.

## Install
**Google Sheets:** open **Extensions -> Apps Script** and paste the `.gs` file into the editor.

**Excel:** press **Alt + F11** to open the VBA editor, paste the `.vba` file, and save it in a new module (`Module1`, `Module2`, ...).

**Office Script:** open the **Automate** tab, add a new script, and paste the `.ts` file.

Each script's helpers are written to stay out of the way of the others, so you can keep several in one project.

## Table of Contents
- [Build Insert](#build-insert)
- [Compare Columns](#compare-columns)
- [Compare Rows](#compare-rows)
- [Compare Sheets](#compare-sheets)
- [Count Distinct](#count-distinct)
- [Delete Duplicate Rows](#delete-duplicate-rows)
- [Find Duplicates](#find-duplicates)
- [Obtain SQL](#obtain-sql)
- [Split Column](#split-column)
- [Trim Whitespace](#trim-whitespace)

# Build Insert
Builds one `INSERT INTO` statement per data row from a header row and the rows below it. Numbers are written bare, text is single-quoted with internal quotes doubled, dates become `'yyyy-mm-dd hh:mm:ss'`, and blank cells become `NULL`.

### Parameters
- `tableName`: the target table, e.g. `"dbo.Users"`.
- `headerRow`: the row holding the column names.
- `firstRow`: the first data row.
- `lastRow`: the last data row. `0` or omitted means "to the end of the data".
- `sheet`: the name of the sheet (default: your current sheet).

### Example Usage
```
=BuildInsert("dbo.Users", 1, 2)
=BuildInsert("dbo.Users", 1, 2, 10)
```

# Compare Columns
Compares two columns of a sheet and returns the rows that differ. Rows whose two cells both look like SQL Server timestamps are skipped unless `includeTimestamps` is TRUE.

### Parameters
- `column1`: the first column letter to compare, e.g. `"A"`.
- `column2`: the second column letter to compare, e.g. `"B"`.
- `sheet`: the name of the sheet (default: your current sheet).
- `includeTimestamps`: when TRUE, every row is compared (default: FALSE).

### Example Usage
```
=CompareColumns("B", "C")
=CompareColumns("B", "C", "Sheet2")
=CompareColumns("B", "C", , TRUE)
```

# Compare Rows
Compares two rows of a sheet and returns the columns that differ.

### Parameters
- `row1`: the first row number to compare.
- `row2`: the second row number to compare.
- `sheet`: the name of the sheet (default: your current sheet).
- `includeTimestamps`: when TRUE, every column is compared (default: FALSE).

### Example Usage
```
=CompareRows(2, 3)
=CompareRows(2, 3, "Sheet2")
=CompareRows(2, 3, , TRUE)
```

# Compare Sheets
Compares two sheets cell by cell over their shared top-left region and returns the cells that differ.

### Parameters
- `sheet1`: the name of the first sheet.
- `sheet2`: the name of the second sheet.
- `includeTimestamps`: when TRUE, every cell is compared (default: FALSE).

### Example Usage
```
=CompareSheets("Sheet1", "Sheet2")
=CompareSheets("Before", "After", TRUE)
```

# Count Distinct
Counts the distinct, non-blank values in a column.

### Parameters
- `column`: the column letter to scan, e.g. `"A"`.
- `sheet`: the name of the sheet (default: your current sheet).

### Example Usage
```
=CountDistinct("A")
=CountDistinct("C", "Sheet2")
```

# Delete Duplicate Rows
Deletes rows whose key columns repeat an earlier row, keeping the first occurrence and removing the later duplicates. Run it as a macro (Alt + F8).

### Parameters
- `keyColumns`: comma-separated column letters that make up the key, e.g. `"A"` or `"A,B,C"` (default: `"A"`).
- `sheet`: the name of the sheet (default: your current sheet).
- `headerRows`: the number of header rows to leave untouched (default: 1).

### Example Usage
```vba
DeleteDuplicateRows
DeleteDuplicateRows "A,B"
DeleteDuplicateRows "A,B", , 2
```

# Find Duplicates
Lists the values that appear more than once in a column, with the rows each one is on.

### Parameters
- `column`: the column letter to scan, e.g. `"A"`.
- `sheet`: the name of the sheet (default: your current sheet).

### Example Usage
```
=FindDuplicates("A")
=FindDuplicates("C", "Sheet2")
```

# Obtain SQL
Builds the SELECT column list for a query out of a header row and a value row: `value1 as [Header1], value2 as [Header2], ...`. Blank values are skipped.

### Parameters
- `headerRow`: the row holding the column headers.
- `valueRow`: the row holding the values to keep as literals.
- `sheet`: the name of the sheet (default: your current sheet).

### Example Usage
```
=ObtainSQL(1, 2)
=ObtainSQL(1, 2, "Sheet2")
```

# Split Column
Splits one column on a delimiter and writes the parts into the columns to its right. Run it as a macro (Alt + F8).

### Parameters
- `column`: the column letter to split (default: `"A"`).
- `delimiter`: the text to split on (default: `","`).
- `sheet`: the name of the sheet (default: your current sheet).

### Example Usage
```vba
SplitColumn
SplitColumn "C", ";"
SplitColumn "C", "|", "Sheet2"
```

# Trim Whitespace
Trims the leading and trailing spaces from every cell in a range, in place. Run it as a macro (Alt + F8).

### Parameters
- `address`: a range (`"A1:C50"`), a whole column (`"A"`), or a named range (default: `"A"`).
- `sheet`: the name of the sheet (default: your current sheet).

### Example Usage
```vba
TrimWhitespace
TrimWhitespace "A1:C100"
TrimWhitespace "B", "Sheet2"
```
