# Clear Downloads

Delete everything inside the current user's Downloads folder.

## Dependencies

- `find` command

## Parameters

- `$1` - Folder to clear (optional, defaults to `~/Downloads`)

## Usage

```bash
clear-downloads [directory]
```

## Example

```bash
clear-downloads
# Output: Deleting all contents in /home/user/Downloads...
# Output: Downloads folder cleared permanently.
```

**Warning:** This permanently deletes every file and folder inside the target directory.
