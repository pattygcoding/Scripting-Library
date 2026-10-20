## JSON to CSV
This script converts JSON files to CSV format. It reads a JSON file containing an array of objects and converts it to a CSV file with headers derived from the object keys.

### Dependencies
- `dkjson`: JSON parsing library for Lua

### Example Usage
```lua
lua json_to_csv.lua
```

### Notes
- Input file: `data.json` (expected to contain an array of objects)
- Output file: `data.csv` (created automatically)
- Make sure the `dkjson` library is installed before running