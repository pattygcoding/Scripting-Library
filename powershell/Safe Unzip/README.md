## Safe Unzip
Safely extracts ZIP files with security checks to prevent zip bombs and directory traversal attacks. Limits file count and total extraction size.

### Parameters
- `-ZipPath`: Path to the ZIP file to extract (mandatory)
- `-MAX_FILE_COUNT`: Maximum number of files allowed (default: 1000)
- `-MAX_TOTAL_SIZE_BYTES`: Maximum total extraction size in bytes (default: 500MB)

### Example Usage
```powershell
safe-unzip "archive.zip"
safe-unzip "archive.zip" -MAX_FILE_COUNT 500 -MAX_TOTAL_SIZE_BYTES 104857600
```