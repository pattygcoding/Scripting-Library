## Dotnet Analysis
This script analyzes captured .NET (ASP.NET Core) console output and prints four grouped sections with line numbers: executed DbCommands (with their database and joined tables), action methods, actions, and endpoints.

### Arguments
- `file`: The log file to analyze. Defaults to `TestFile1.txt`.

### Example Usage
```
python dotnet_analysis.py log.txt
```
