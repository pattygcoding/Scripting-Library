## Neovim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Neovim.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **Neovim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```lua
lua neovim.lua example.txt
```
