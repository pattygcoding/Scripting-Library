# Dotnet Analysis

Analyze .NET application log files to extract and categorize executed database commands, action methods, actions, and endpoints.

## Description

This script processes .NET application log files to extract and organize different types of execution information. It's particularly useful for analyzing ASP.NET Core application logs to understand database usage patterns, controller actions, and endpoint executions.

## Dependencies

- Log file with .NET application output
- `awk`, `sort`, `grep` commands
- Bash associative arrays support

## Parameters

- `$1` - **Log file path** (optional): Path to the log file to analyze. Defaults to `TestFile1.txt`

## Usage

```bash
dotnet-analysis [log_file]
```

## How it works

1. Scans the log file line by line
2. Identifies and categorizes different types of execution logs:
   - **Executed DbCommand**: Database queries and commands
   - **Executed action method**: Controller action method executions
   - **Executed action**: General action executions
   - **Executed endpoint**: API endpoint executions
3. Groups related DbCommand blocks together
4. Sorts all categories by line number
5. Displays organized output with color coding

## Examples

```bash
# Analyze default log file
dotnet-analysis

# Analyze specific log file
dotnet-analysis application.log

# Analyze ASP.NET Core application logs
dotnet-analysis /var/log/myapp/app.log
```

## Sample Output

```bash
--- Executed DbCommands ---
12-15 SELECT * FROM Users WHERE Id = @p0
18-20 INSERT INTO AuditLog (Action, UserId) VALUES (@p0, @p1)
25-27 UPDATE Users SET LastLogin = @p0 WHERE Id = @p1

--- Executed Action Methods ---
10 Executed action method UserController.GetUser (MyApp.Controllers)
23 Executed action method UserController.UpdateProfile (MyApp.Controllers)

--- Executed Actions ---
11 Executed action UserController.GetUser (MyApp.Controllers)
24 Executed action UserController.UpdateProfile (MyApp.Controllers)

--- Executed Endpoints ---
9 Executed endpoint 'GET /api/users/{id}'
22 Executed endpoint 'PUT /api/users/profile'
```

## Log Pattern Recognition

The script recognizes these log patterns:

### DbCommand Blocks
```
Executed DbCommand (45ms) [Parameters=[@p0='123'], CommandType='Text', CommandTimeout='30']
SELECT * FROM Users WHERE Id = @p0
```

### Action Methods
```
Executed action method UserController.GetUser (MyApp.Controllers)
```

### Actions
```
Executed action UserController.GetUser (MyApp.Controllers)
```

### Endpoints
```
Executed endpoint 'GET /api/users/{id}'
```

## Features

- **Multi-line DbCommand support**: Handles complex SQL queries spanning multiple lines
- **Line number tracking**: Shows where each execution occurs in the log
- **Grouped output**: Related database commands are grouped together
- **Sorted results**: All categories are sorted by line number for chronological analysis
- **Color-coded output**: Uses ANSI colors for better readability

## Use Cases

- Performance analysis of database operations
- Debugging API endpoint execution flow
- Monitoring controller action usage
- Identifying frequently executed database queries
- Analyzing application execution patterns
- Troubleshooting slow database operations

## Notes

- The script assumes standard ASP.NET Core logging format
- DbCommand blocks may span multiple lines and are processed as complete units
- Line numbers help correlate events in the original log file
- Empty or malformed lines are ignored
- Color output may not display correctly in all terminals