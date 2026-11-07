# Search Match

Search files of a given extension for one or more terms, printing each matching line with its line number.

## Dependencies

- `find` command

## Parameters

- `$1` - File extension to search (e.g. `.cs`)
- `$2...` - One or more terms to search for
- `--uncapped` - List more than the limit of 3000 results
- `--cross` - Only report files that contain all of the specified terms
- `--dir` - Display full file paths, not just file names
- `--calls` - Only match when a period precedes the term (useful for method calls)

## Usage

```bash
search-match <extension> <term> [term...] [options]
```

## Example

```bash
search-match .cs SearchTerm1 SearchTerm2 --cross --dir
```
