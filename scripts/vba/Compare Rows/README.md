# Compare Rows

Compares two rows of a sheet and returns the columns that differ.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `row1` | number | First row number to compare, e.g. `2`. |
| `row2` | number | Second row number to compare, e.g. `3`. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |
| `includeTimestamps` | boolean | When `TRUE`, every column is compared. When `FALSE` (default), columns whose two cells both look like SQL Server timestamps are skipped, since those always differ. |

## Returns

A newline-separated report of the differing columns (`Column C: value1 vs value2`), or `"No differences"`.

## Platforms

- **Excel (VBA)** — `CompareRows.vba`
- **Google Sheets (Apps Script)** — `compareRows.gs`
- **Office Script (TypeScript)** — `compareRows.ts`

## Examples

```
=CompareRows(2, 3)
=CompareRows(2, 3, "Sheet2")
=CompareRows(2, 3, , TRUE)
```
