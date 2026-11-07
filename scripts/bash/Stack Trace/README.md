# Stack Trace

Parse a stack trace file and print the relative file path from each frame, filtering out Microsoft framework calls for cleaner debugging output.

## Parameters

- `$1` - Stack trace file (optional, defaults to `test.txt`)

## Usage

```bash
stack-trace [file]
```

## Example

```bash
stack-trace error.txt
# Output: src/File.cs:line 10
```
