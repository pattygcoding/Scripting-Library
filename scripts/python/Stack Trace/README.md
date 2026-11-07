## Stack Trace
This script parses a stack trace file and prints the relative file path from each frame, filtering out Microsoft framework calls for cleaner debugging output.

### Arguments
- `path`: Path to the stack trace file. Defaults to `test.txt`.

### Example Usage
```
python stack_trace.py
python stack_trace.py error.txt
```
