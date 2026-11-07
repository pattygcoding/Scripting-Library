## Nginx
This script starts or reloads an Nginx server. If Nginx is already running it reloads the configuration; otherwise it starts a new instance.

### Dependencies
- **Nginx**: Must be installed, with its path configured in `NGINX_BASE` or passed with `--base`.

### Arguments
- `--base`: Nginx installation directory. Defaults to the `NGINX_BASE` constant.

### Example Usage
```
ruby nginx.rb --base "C:\nginx"
```
