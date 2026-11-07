# Compare Sheets

Compares two sheets cell by cell over their shared top-left region and returns the cells that differ.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `sheet1` | string | First sheet name. |
| `sheet2` | string | Second sheet name. |
| `includeTimestamps` | boolean | When `TRUE`, every cell is compared. When `FALSE` (default), cells whose two values both look like SQL Server timestamps are skipped. |

## Returns

A newline-separated report of the differing cells (`Cell C4: value1 vs value2`), or `"No differences"`. Comparison runs over the rows and columns the two sheets share.

## Platforms

- **Excel (VBA)** — `CompareSheets.vba`
- **Google Sheets (Apps Script)** — `compareSheets.gs`
- **Office Script (TypeScript)** — `compareSheets.ts`

## Examples

```
=CompareSheets("Sheet1", "Sheet2")
=CompareSheets("Before", "After", TRUE)
```
