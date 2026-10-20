## Cache Visual Studio Index
Creates and updates an index of .cs files in the current directory tree. Tracks changes in file locations and reports additions, deletions, and modifications.

### Dependencies
Must have write access to an index file in the directory you are executing

### Parameters
- `-Root`: Root directory to scan (default: current location)
- `-IndexFile`: Path to the index file (must be specified)

### Example Usage
```powershell
cache-vsindex -Root "C:\MyProject" -IndexFile "index.txt"
```