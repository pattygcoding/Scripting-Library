## Compare Diff
Compares two files line by line and highlights the differences. It can also ignore timestamps if specified.

### Dependencies
Must have 2 named .txt files in the same directory you are executing in (see parameters)

### Parameters
- `-f1`: First file to compare (default: "TestFile1.txt").
- `-f2`: Second file to compare (default: "TestFile2.txt").
- `-notime`: Switch to ignore timestamps in the comparison.

### Example Usage
```powershell
compare-diff -f1 "File1.txt" -f2 "File2.txt" -notime
```
