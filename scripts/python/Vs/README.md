## Vs
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio. A bare class name is treated as `<name>.cs`.

### Dependencies
- **Visual Studio**: `devenv.exe` must be in your PATH (integration uses `pywin32`)

### Arguments
- `file`: File name or C# class name to search for (required).

### Example Usage
```
python vs.py example.cs
python vs.py Program
```
