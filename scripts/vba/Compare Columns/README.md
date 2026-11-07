# Compare Columns

Compares two columns of a sheet and returns the rows that differ.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `column1` | string | First column letter to compare, e.g. `"A"`. |
| `column2` | string | Second column letter to compare, e.g. `"B"`. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |
| `includeTimestamps` | boolean | When `TRUE`, every row is compared. When `FALSE` (default), rows whose two cells both look like SQL Server timestamps are skipped, since those always differ. |

## Returns

A newline-separated report of the differing rows (`Row 4: value1 vs value2`), or `"No differences"`.

## Platforms

- **Excel (VBA)** — `CompareColumns.vba`, used in a cell as `=CompareColumns(...)`.
- **Google Sheets (Apps Script)** — `compareColumns.gs`, used as a custom function.
- **Office Script (TypeScript)** — `compareColumns.ts`, run from the Automate tab.

## Examples

```
=CompareColumns("B", "C")
=CompareColumns("B", "C", "Sheet2")
=CompareColumns("B", "C", , TRUE)
```
