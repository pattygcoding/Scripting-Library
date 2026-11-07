# Delete Duplicate Rows

Deletes rows whose key columns repeat an earlier row, keeping the first occurrence and removing the later duplicates.

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `keyColumns` | string | Comma-separated column letters that make up the key, e.g. `"A"` or `"A,B,C"`. Defaults to `"A"`. |
| `sheet` | string | Optional sheet name. Defaults to the active sheet. |
| `headerRows` | number | Number of header rows to leave untouched. Defaults to `1`. |

## Returns

A short summary (`N duplicate row(s) deleted`), or a message when there is nothing to do.

## Platforms

- **Excel (VBA)** — `DeleteDuplicateRows.vba`, run as a macro (Alt + F8).
- **Google Sheets (Apps Script)** — `deleteDuplicateRows.gs`.
- **Office Script (TypeScript)** — `deleteDuplicateRows.ts`.

## Examples

```vba
DeleteDuplicateRows                ' key = column A, one header row
DeleteDuplicateRows "A,B"          ' key = columns A and B
DeleteDuplicateRows "A,B", , 2     ' key = A and B, two header rows
```
