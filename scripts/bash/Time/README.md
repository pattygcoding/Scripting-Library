# Time

Measure and display the execution time of any command.

## Description

This script provides precise timing functionality for measuring how long any command takes to execute. It captures the command's execution time with nanosecond precision and displays the result in seconds, while preserving the original command's output and exit code.

## Dependencies

- `date` command with nanosecond precision (`+%s.%N`)
- `bc` calculator for floating-point arithmetic

## Parameters

- `$@` - **Command and arguments** (required): The command and its arguments to time

## Usage

```bash
time command [args...]
```

## How it works

1. Records the start time with nanosecond precision
2. Executes the provided command with all its arguments
3. Captures the command's exit code
4. Records the end time
5. Calculates elapsed time using `bc` for precision
6. Displays the execution time in seconds
7. Returns the original command's exit code

## Examples

```bash
# Time a simple command
time ls -la
```
**Output:**
```
total 48
drwxr-xr-x  8 user user 4096 Dec  1 10:30 .
drwxr-xr-x  3 user user 4096 Dec  1 10:29 ..
-rw-r--r--  1 user user  220 Dec  1 10:29 .bashrc
...

The task took 0.023456 seconds to complete.
```

```bash
# Time a file operation
time find /usr -name "*.txt" | wc -l
```
**Output:**
```
1247

The task took 2.345678 seconds to complete.
```

```bash
# Time a compilation
time gcc -o myprogram myprogram.c
```
**Output:**
```
The task took 1.234567 seconds to complete.
```

## Precision and Accuracy

- **Resolution**: Nanosecond precision (up to 9 decimal places)
- **Display**: Shows full precision in seconds
- **Calculation**: Uses `bc` for accurate floating-point arithmetic
- **Real Time**: Measures wall-clock time (not CPU time)

## Exit Code Preservation

The script preserves the original command's exit code:

```bash
# Successful command
time echo "Hello"
echo $?  # Returns 0

# Failed command  
time ls /nonexistent
echo $?  # Returns non-zero (ls error code)
```

## Comparison with System `time`

**This script:**
- ✅ Simple, readable output
- ✅ Shows only elapsed time
- ✅ Preserves command output formatting
- ✅ Returns original exit codes

**System `time` command:**
- Shows real, user, and sys time
- Different output format
- May interfere with command output

## Use Cases

**Development:**
```bash
# Build timing
time make all

# Test execution time
time npm test

# Script performance
time ./deploy.sh
```

**System Administration:**
```bash
# Backup timing
time tar -czf backup.tar.gz /home/user/

# Database operations
time mysqldump database > backup.sql

# File operations
time rsync -av source/ destination/
```

**Performance Analysis:**
```bash
# Algorithm comparison
time python algorithm1.py
time python algorithm2.py

# Network operations
time wget https://example.com/largefile.zip
```

## Output Format

The timing output always appears after the command output:
```
[Command output appears here]

The task took X.XXXXXX seconds to complete.
```

## Error Handling

**Command not found:**
```bash
time nonexistentcommand
# Output: bash: nonexistentcommand: command not found
# Output: The task took 0.001234 seconds to complete.
# Exit code: 127 (command not found)
```

**No command provided:**
```bash
time
# Output: You must pass a command to time.
# Exit code: 1
```

## Limitations

- Measures wall-clock time, not CPU time
- Precision depends on system clock resolution
- Does not separate user and system time
- Output timing appears after command completes

## Notes

- The script works with any command, including complex pipelines
- Timing includes the full command execution, including I/O waits
- Compatible with both simple commands and complex shell operations
- The timing message uses colored output for visibility
- Floating-point arithmetic requires `bc` to be installed on the system