# Count Distinct

Counts the distinct, non-blank values in a column.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `column` | string | Column letter to scan, e.g. `"A"`. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |

## Returns

The number of distinct values. Blank cells are ignored.

## Platforms

- **Excel (VBA)** — `CountDistinct.vba`
- **Google Sheets (Apps Script)** — `countDistinct.gs`
- **Office Script (TypeScript)** — `countDistinct.ts`

## Examples

```
=CountDistinct("A")
=CountDistinct("C", "Sheet2")
```
