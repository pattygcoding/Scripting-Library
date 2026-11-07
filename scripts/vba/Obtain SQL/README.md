# Obtain SQL

Builds the SELECT column list for a query out of a header row and a value row: `value1 as [Header1], value2 as [Header2], ...`.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `headerRow` | number | Row holding the column headers. |
| `valueRow` | number | Row holding the values to keep as literals. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |

## Returns

The comma-and-newline separated column list. Cells whose value is blank are skipped.

## Platforms

- **Excel (VBA)** — `ObtainSQL.vba`
- **Google Sheets (Apps Script)** — `obtainSql.gs`
- **Office Script (TypeScript)** — `obtainSql.ts`

## Examples

```
=ObtainSQL(1, 2)
=ObtainSQL(1, 2, "Sheet2")
```

Given a header row of `id | name | email` and a value row of `1 | Jane |` (blank email), returns:

```
1 as [id],
Jane as [name]
```
