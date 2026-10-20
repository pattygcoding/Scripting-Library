# Compare Diff

Compare two files with colorized diff output, with option to ignore timestamps.

## Description

This script provides an enhanced file comparison tool with colorized output that makes it easy to spot differences between two files. It includes the ability to filter out timestamp patterns, making it useful for comparing log files or other timestamped content.

## Dependencies

- `diff` command
- `sed` command for timestamp filtering
- `mktemp` command for temporary file creation

## Parameters

- `$1` - **First file** (optional): First file to compare. Defaults to `TestFile1.txt`
- `$2` - **Second file** (optional): Second file to compare. Defaults to `TestFile2.txt`
- `$3` - **--notime flag** (optional): When set to `--notime`, timestamps will be filtered out before comparison

## Usage

```bash
compare-diff [file1] [file2] [--notime]
```

## How it works

1. Validates that both files exist
2. If `--notime` flag is provided, removes timestamp patterns from both files:
   - `[HH:MM:SS AM/PM]` format timestamps
   - `(###ms)` format execution times
3. Creates temporary cleaned files for comparison
4. Runs diff with custom formatting for colored output
5. Cleans up temporary files

## Examples

```bash
# Compare default test files
compare-diff

# Compare specific files
compare-diff app.log backup.log

# Compare files while ignoring timestamps
compare-diff log1.txt log2.txt --notime

# Compare configuration files
compare-diff config.json config.backup.json
```

## Output Format

The script provides color-coded diff output:
- **RED lines** (prefixed with `-`): Content from the first file
- **GREEN lines** (prefixed with `+`): Content from the second file
- Header shows which file is represented by each color

**Sample Output:**
```bash
RED   = app.log
GREEN = app.backup.log

- [10:30:15 AM] User login failed for user@example.com
+ [10:30:15 AM] User login successful for user@example.com
- Processing took (150ms)
+ Processing took (75ms)
```

## Timestamp Filtering

When using the `--notime` flag, the following patterns are removed:
- `[HH:MM:SS AM/PM]` - Standard time format
- `(###ms)` - Execution time in milliseconds

This is particularly useful for:
- Comparing log files where only the content matters
- Analyzing application output without timing variations
- Focusing on functional differences rather than temporal ones

## Use Cases

- Comparing application log files
- Analyzing configuration file changes
- Reviewing code output differences
- Debugging by comparing program outputs
- Quality assurance testing with timestamped data

## Notes

- Files must exist or the script will return with error code 1
- Temporary files are automatically cleaned up after comparison
- The script preserves all original files unchanged
- Color output may not display correctly in all terminals