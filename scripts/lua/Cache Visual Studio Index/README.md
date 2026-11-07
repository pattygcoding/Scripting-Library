## Cache Visual Studio Index
This script builds and updates an index of `.cs` files under a directory tree. It maps each file's base name to the directories that contain it and reports the entries that were added, removed, or changed.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`

### Arguments
- `--root`: Root directory to scan. Defaults to the current directory.
- `--index-file`: Path to the index file to create or update (required).

### Example Usage
```lua
lua cache-vsindex.lua --root "C:\MyProject" --index-file index.txt
```
