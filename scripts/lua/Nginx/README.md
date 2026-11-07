## Nginx
This script starts or reloads an Nginx server. If Nginx is already running it reloads the configuration; otherwise it starts a new instance.

### Dependencies
- **Nginx**: Must be installed, with its path passed with `--base`.

### Arguments
- `--base`: Nginx installation directory.

### Example Usage
```lua
lua nginx.lua --base "C:\nginx"
```
