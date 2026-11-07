## Safe Unzip
This script safely extracts a ZIP file, rejecting unsafe (path-traversal) entries and aborting if the file count or total uncompressed size exceeds the configured limits. It reads the ZIP central directory to validate the archive before extracting.

### Dependencies
- Windows: PowerShell (`Expand-Archive`)
- POSIX: `unzip`

### Arguments
- `zip_path`: Path to the ZIP file to extract (required).
- `--max-file-count`: Maximum number of files allowed. Defaults to `1000`.
- `--max-total-size`: Maximum total uncompressed size in bytes. Defaults to `524288000` (500 MB).

### Example Usage
```lua
lua safe-unzip.lua archive.zip
lua safe-unzip.lua archive.zip --max-file-count 500 --max-total-size 104857600
```
