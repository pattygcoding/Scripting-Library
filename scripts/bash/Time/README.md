# Time

Measure and display the execution time of any command.

> **Note:** The function is named `timer` (not `time`) because `time` is a reserved word in bash.

## Dependencies

- `date` command with nanosecond precision (`+%s.%N`)
- `bc` calculator for floating-point arithmetic (falls back to `awk` when absent)

## Parameters

- `$@` - **Command and arguments** (required): The command and its arguments to time

## Usage

```bash
timer command [args...]
```

## How it works

1. Records the start time with nanosecond precision
2. Executes the provided command with all its arguments
3. Captures the command's exit code
4. Records the end time and calculates the elapsed time
5. Displays the elapsed time in seconds and returns the command's exit code

## Examples

```bash
# Time a simple command
timer ls -la

# Time a build
timer make all

# Time a network operation
timer wget https://example.com/largefile.zip
```

**Output:**
```
[Command output appears here]

The task took 0.023456 seconds to complete.
```

## Exit Code Preservation

The original command's exit code is preserved:

```bash
timer echo "Hello"
echo $?  # Returns 0

timer ls /nonexistent
echo $?  # Returns non-zero (ls error code)
```

## Error Handling

```bash
timer
# Output: timer: you must pass a command to time.
# Exit code: 1
```
