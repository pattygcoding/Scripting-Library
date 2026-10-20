# Vs

Open files in Visual Studio using a cached index for fast file discovery. Searches for .cs files by name.

## Description

This script provides a fast way to open C# files in Visual Studio by leveraging a cached index of file locations. It can search for files using either a pre-built cache (for speed) or by scanning the filesystem (as fallback), making it ideal for large .NET projects where quick file access is important.

## Dependencies

- Visual Studio (`devenv.exe`)
- PowerShell for launching Visual Studio
- Cached index file (created by `cache-vsindex` script)
- `find` command for filesystem fallback

## Parameters

- `$1` - **File name** (required): Name of the C# file to search for (`.cs` extension optional)
- `$2` - **Index file path** (optional): Path to the cached index file

## Usage

```bash
vs filename [index_file]
```

## How it works

1. **Input Processing**: Accepts filename with or without `.cs` extension
2. **Cache Lookup**: Searches cached index for file locations (if available)
3. **Filesystem Fallback**: Falls back to filesystem search if not in cache
4. **Directory Exclusions**: Excludes common non-source directories (`bin`, `obj`, `.git`, `node_modules`)
5. **Visual Studio Launch**: Opens found files in Visual Studio using PowerShell

## Examples

```bash
# Open a controller file (cache lookup)
vs UserController
```
**Output:**
```bash
Opened (cache): ./Controllers/UserController.cs
```

```bash
# Open with explicit .cs extension
vs AuthService.cs
```
**Output:**
```bash
Opened (cache): ./Services/AuthService.cs
```

```bash
# Filesystem search (file not in cache)
vs NewComponent
```
**Output:**
```bash
Opened (fs): ./Components/NewComponent.cs
```

```bash
# Use custom index file
vs ProductModel /custom/path/vs-index.txt
```

## Cache vs Filesystem Search

### Cache Search (Fast)
- ✅ **Speed**: Instant lookup
- ✅ **Efficiency**: No disk scanning  
- ✅ **Multiple locations**: Handles files with same name in different directories
- ❌ **Dependency**: Requires up-to-date cache file

### Filesystem Search (Fallback)
- ✅ **Comprehensive**: Finds all .cs files
- ✅ **No cache needed**: Works without pre-built index
- ✅ **Always current**: Reflects current filesystem state
- ❌ **Slower**: Scans directory tree
- ❌ **Resource intensive**: I/O heavy for large projects

## Cache File Format

The cache file (created by `cache-vsindex`) uses this format:
```
ClassName|/path/to/dir1;/path/to/dir2
UserController|./Controllers;./Legacy/Controllers  
ProductService|./Services
```

## Directory Exclusions

These directories are excluded from filesystem searches:
- `bin/` - Build output
- `obj/` - Build intermediates  
- `.git/` - Version control
- `node_modules/` - Node.js dependencies

## Visual Studio Integration

**File Opening Process:**
1. PowerShell executes `devenv.exe /Edit [file-paths]`
2. Visual Studio opens with specified files loaded
3. Files open in editor tabs, ready for editing

**Multiple Files:**
If multiple files with the same name exist, all are opened:
```bash
vs Config
# Opens: ./Config/Config.cs, ./Legacy/Config.cs, ./Tests/Config.cs
```

## Error Handling

**No file provided:**
```bash
vs
# Output: Please provide a file name.
# Exit code: 1
```

**File not found:**
```bash
vs NonExistentFile
# Output: No instances of 'NonExistentFile.cs' found under '/current/directory'.
# Exit code: 1
```

## Performance Optimization

**For best performance:**
1. **Build cache regularly**: Run `cache-vsindex` to maintain index
2. **Update after changes**: Rebuild cache when adding/moving files
3. **Use specific names**: More specific filenames reduce ambiguity

**Cache building:**
```bash
# Build cache for current project
cache-vsindex . vs-cache.txt

# Use the cache
vs MyClass vs-cache.txt
```

## Integration with Development Workflow

**Project Setup:**
```bash
# Navigate to project root
cd /path/to/dotnet-project

# Build initial cache
cache-vsindex . .vs-cache

# Open files quickly
vs UserController .vs-cache
vs ProductService .vs-cache
```

**Development Workflow:**
```bash
# Quick file opening during development
vs HomeController    # Open main controller
vs UserService      # Open service layer
vs ApplicationDbContext  # Open database context
```

## Use Cases

- **Rapid Development**: Quick file access in large .NET projects
- **Code Navigation**: Fast switching between related files
- **Refactoring**: Opening multiple related files simultaneously  
- **Code Reviews**: Quick access to specific classes/files
- **Debugging**: Fast navigation to problematic files

## Notes

- Script assumes Windows environment with Visual Studio installed
- PowerShell integration provides Windows-specific functionality
- File search is case-sensitive for filenames
- Multiple matching files will all be opened in Visual Studio
- Cache lookups are significantly faster than filesystem searches
- Works best with properly maintained cache files