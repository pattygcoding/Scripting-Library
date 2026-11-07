# Split Column

Splits one column on a delimiter and writes the parts into the columns to its right.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `column` | string | Column letter to split. Defaults to `"A"`. |
| `delimiter` | string | Text to split on. Defaults to `","`. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |

## Returns

A short summary (`N column(s) written from COLUMN`). Each part is trimmed; rows with fewer parts than the widest cell are padded with blanks.

## Platforms

- **Excel (VBA)** — `SplitColumn.vba`, run as a macro (Alt + F8).
- **Google Sheets (Apps Script)** — `splitColumn.gs`.
- **Office Script (TypeScript)** — `splitColumn.ts`.

## Examples

```vba
SplitColumn                     ' split column A on ","
SplitColumn "C", ";"            ' split column C on ";"
SplitColumn "C", "|", "Sheet2"  ' split column C of Sheet2 on "|"
```
