## JSON to CSV
This script converts JSON data files to CSV format. It reads a JSON file containing an array of objects and converts it to a CSV file with headers from the object keys.

### Dependencies
- `json` gem (Ruby standard library)
- `csv` gem (Ruby standard library)

### Example Usage
```ruby
ruby json_to_csv.rb
```

**Note:** By default, the script looks for `data.json` in the current directory and outputs `data.csv`. Modify the file paths in the script as needed.