# Trim Whitespace

Trims the leading and trailing spaces from every cell in a range, in place.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `address` | string | A range (`"A1:C50"`), a whole column (`"A"`), or a named range. Defaults to `"A"`. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |

## Returns

A short summary (`N cell(s) trimmed`). Only cells whose trimmed text differs are written back.

## Platforms

- **Excel (VBA)** — `TrimWhitespace.vba`, run as a macro (Alt + F8).
- **Google Sheets (Apps Script)** — `trimWhitespace.gs`.
- **Office Script (TypeScript)** — `trimWhitespace.ts`.

## Examples

```vba
TrimWhitespace                      ' trims column A of the active sheet
TrimWhitespace "A1:C100"            ' trims a rectangular range
TrimWhitespace "B", "Sheet2"        ' trims column B of Sheet2
```
