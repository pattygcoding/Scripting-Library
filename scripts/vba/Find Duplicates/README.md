# Find Duplicates

Lists the values that appear more than once in a column, with the rows each one is on.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `column` | string | Column letter to scan, e.g. `"A"`. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |

## Returns

A newline-separated report (`alice (rows 3, 7, 9)`), or `"No duplicates"`. Blank cells are ignored.

## Platforms

- **Excel (VBA)** — `FindDuplicates.vba`
- **Google Sheets (Apps Script)** — `findDuplicates.gs`
- **Office Script (TypeScript)** — `findDuplicates.ts`

## Examples

```
=FindDuplicates("A")
=FindDuplicates("C", "Sheet2")
```
