## Gensql Count
This script generates a SQL script you can use to count the number of entries in a given table.

### Arguments
- `-t`, `--table`: The table name (optionally schema-qualified) (required).

### Example Usage
```lua
lua gensql-count.lua -t "[db].[Table]"
```
