## Safe Unzip
This script safely extracts a ZIP file, rejecting unsafe (path-traversal) entries and aborting if the file count or total uncompressed size exceeds the configured limits.

### Dependencies
- `rubyzip`: `gem install rubyzip`

### Arguments
- `zip_path`: Path to the ZIP file to extract (required).
- `--max-file-count`: Maximum number of files allowed. Defaults to `1000`.
- `--max-total-size`: Maximum total uncompressed size in bytes. Defaults to `524288000` (500 MB).

### Example Usage
```
ruby safe-unzip.rb archive.zip
ruby safe-unzip.rb archive.zip --max-file-count 500 --max-total-size 104857600
```
