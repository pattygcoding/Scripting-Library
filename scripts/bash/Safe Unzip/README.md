# Safe Unzip

Safely extract zip files with built-in security checks to prevent zip bombs and directory traversal attacks.

## Description

This script provides a secure way to extract zip files with built-in protections against common zip file vulnerabilities. It includes safeguards against zip bombs (files that expand to enormous sizes) and directory traversal attacks (zip slip vulnerabilities).

## Dependencies

- `unzip` command
- `zipinfo` command  
- `awk` and `grep` commands for text processing
- `mkdir` command

## Parameters

- `$1` - **Zip file path** (required): Path to the zip file to extract
- `$2` - **Maximum file count** (optional): Maximum number of files allowed. Defaults to 1000
- `$3` - **Maximum total size in bytes** (optional): Maximum total uncompressed size. Defaults to 524,288,000 bytes (500MB)

## Usage

```bash
safe-unzip <zip-path> [max-files] [max-bytes]
```

## How it works

1. **Validation**: Checks if zip file exists
2. **Pre-analysis**: Uses `zipinfo` to analyze zip contents without extracting
3. **Security Checks**:
   - Directory traversal protection (prevents `../` paths)
   - File count limits (prevents zip bombs with many files)
   - Size limits (prevents zip bombs with huge files)
4. **Safe Extraction**: Only extracts if all security checks pass
5. **Output Directory**: Creates a directory named `{zipname}_unzipped`

## Examples

```bash
# Extract with default limits (1000 files, 500MB max)
safe-unzip archive.zip
```

**Output:**
```bash
Extracted to: archive_unzipped
```

```bash
# Extract with custom limits
safe-unzip large-project.zip 2000 1073741824
# 2000 files max, 1GB max size
```

**Output:**
```bash
Extracted to: large-project_unzipped
```

## Security Features

### Directory Traversal Protection
**Prevents extraction of files with dangerous paths:**
```bash
safe-unzip malicious.zip
# Output: Aborted: Unsafe path detected: ../../../etc/passwd
```

### File Count Protection  
**Prevents zip bombs with excessive file counts:**
```bash
safe-unzip zipbomb.zip 100
# Output: Aborted: File count exceeds limit of 100
```

### Size Protection
**Prevents zip bombs with huge uncompressed sizes:**
```bash
safe-unzip hugefile.zip 1000 104857600
# Output: Aborted: Total uncompressed size exceeds 100 MB
```

## Default Limits

- **Maximum Files**: 1,000 files
- **Maximum Size**: 500 MB (524,288,000 bytes)
- **Path Security**: No `../` sequences allowed

## Custom Limits Examples

```bash
# Very restrictive (small projects)
safe-unzip project.zip 50 10485760  # 50 files, 10MB

# More permissive (large projects)  
safe-unzip dataset.zip 5000 2147483648  # 5000 files, 2GB

# Moderate limits
safe-unzip backup.zip 1500 1073741824  # 1500 files, 1GB
```

## Error Scenarios

**File not found:**
```bash
safe-unzip nonexistent.zip
# Output: Error: Zip file not found: nonexistent.zip
```

**Invalid usage:**
```bash
safe-unzip
# Output: Usage: safe-unzip <zip-path> [max-files] [max-bytes]
```

## Output Directory

- **Format**: `{original_filename}_unzipped`
- **Example**: `project.zip` → `project_unzipped/`
- **Creation**: Directory is created if it doesn't exist
- **Location**: Same directory as the zip file

## Zip Bomb Protection

**Common zip bomb characteristics this script prevents:**
- Files that expand from KB to GB
- Archives with millions of tiny files
- Nested archives that expand exponentially
- Paths designed to overwrite system files

## Use Cases

- Extracting user-uploaded zip files safely
- Processing zip files from untrusted sources  
- Automated backup restoration with size limits
- Secure file processing in server environments
- Preventing resource exhaustion from malicious archives

## Performance Notes

- Pre-analysis is fast (only reads zip directory)
- No extraction occurs if limits are exceeded
- Memory usage is minimal during analysis
- Extraction speed depends on zip size and system performance

## Notes

- The script analyzes the entire zip contents before extracting anything
- Directories within the zip don't count toward file limits
- Size calculations are based on uncompressed file sizes
- The script creates a new directory for extracted contents
- Silent extraction (`-q` flag) for cleaner output