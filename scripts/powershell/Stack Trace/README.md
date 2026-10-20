## Stack Trace
Parses stack trace files to extract and display relative file paths, filtering out Microsoft framework calls for cleaner debugging output.

### Parameters
- `-Path`: Path to the stack trace file (default: "test.txt")

### Example Usage
```powershell
stack-trace
stack-trace -Path "error.txt"
```