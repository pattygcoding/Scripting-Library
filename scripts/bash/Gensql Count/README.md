# Gensql Count

Generate a SQL script you can use to count the number of entries in a given table.

## Parameters

- `$1` - Table name (optionally schema-qualified) (required)

## Usage

```bash
gensql-count <table>
```

## Example

```bash
gensql-count "[db].[Table]"
# Output: SELECT COUNT(*) AS total_entries
# Output: FROM [db].[Table];
```
