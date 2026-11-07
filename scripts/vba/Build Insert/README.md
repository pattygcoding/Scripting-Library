# Build Insert

Builds one `INSERT INTO` statement per data row from a header row and the rows below it.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `tableName` | string | Target table, e.g. `"dbo.Users"`. |
| `headerRow` | number | Row holding the column names. |
| `firstRow` | number | First data row. |
| `lastRow` | number | Last data row. `0` or omitted means "to the end of the data". |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |

## Returns

One `INSERT INTO [table] ([cols]) VALUES (...);` statement per row, newline separated. Numbers are written bare, text is single-quoted with internal quotes doubled, dates become `'yyyy-mm-dd hh:mm:ss'`, and blank cells become `NULL`.

## Platforms

- **Excel (VBA)** — `BuildInsert.vba`
- **Google Sheets (Apps Script)** — `buildInsert.gs`
- **Office Script (TypeScript)** — `buildInsert.ts`

## Examples

```
=BuildInsert("dbo.Users", 1, 2)
=BuildInsert("dbo.Users", 1, 2, 10)
```

Given headers `id | name | email` and the row `1 | Jane |` (blank email), returns:

```sql
INSERT INTO [dbo.Users] ([id], [name], [email]) VALUES (1, 'Jane', NULL);
```
