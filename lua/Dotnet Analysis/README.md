## Dotnet Analysis
This script analyzes .NET application log files to extract and display executed action methods, actions, endpoints, and database commands. It provides colored output and groups similar database operations for better readability.

### Arguments
- `filename`: The log file to analyze (default is `TestFile1.txt`)

### Dependencies
- Standard Lua libraries (no external dependencies required)

### Example Usage
```lua
lua dotnet-analysis.lua logfile.txt
```