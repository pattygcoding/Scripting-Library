## Vs
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio. A bare class name is treated as `<name>.cs`.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **Visual Studio**: `devenv.exe` must be in your PATH

### Arguments
- `file`: File name or C# class name to search for (required).

### Example Usage
```lua
lua vs.lua example.cs
lua vs.lua Program
```
