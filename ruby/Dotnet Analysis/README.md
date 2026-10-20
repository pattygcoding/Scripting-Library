## Dotnet Analysis
This script analyzes .NET application log files to extract and group database commands, action methods, executed actions, and endpoints. It provides a structured view of application execution with color-coded output.

### Arguments
- `file`: The log file to analyze (defaults to "TestFile1.txt" if not provided)

### Dependencies
- Ruby standard library (no external gems required)

### Example Usage
```ruby
ruby dotnet-analysis.rb logfile.txt
```