# Nginx

Start nginx server or reload configuration if already running.

## Description

This script manages an nginx web server by either starting it (if not running) or reloading its configuration (if already running). It's designed to work in Windows environments using PowerShell to execute nginx commands.

## Dependencies

- Nginx installation
- PowerShell for command execution
- `pgrep` command for process detection
- Properly configured nginx installation path

## Configuration Required

⚠️ **Important**: Before using this script, you must configure the `nginx_base` variable in the script to point to your nginx installation directory.

```bash
nginx_base="/path/to/your/nginx/installation"  # Update this path
```

## Usage

```bash
nginx
```

## How it works

1. **Process Detection**: Uses `pgrep` to check if nginx is currently running
2. **If Running**: Executes `nginx -s reload` to reload configuration
3. **If Not Running**: Starts nginx with the specified configuration file
4. **PowerShell Execution**: Uses PowerShell for Windows compatibility

## Configuration Setup

Before first use, edit the script to set your nginx paths:

```bash
# Example configuration
nginx_base="/c/nginx-1.20.2"
nginx_exe="$nginx_base/nginx.exe"
nginx_conf="$nginx_base/conf/nginx.conf"
```

## Examples

```bash
# Start nginx (if not running) or reload (if running)
nginx

# If nginx is not running:
# - Starts nginx with configuration from conf/nginx.conf

# If nginx is already running:
# - Reloads nginx configuration without stopping the server
```

## Use Cases

- **Development**: Quickly restart nginx during development
- **Configuration Updates**: Reload nginx after changing configuration files
- **Server Management**: Simple nginx lifecycle management
- **Automated Scripts**: Part of deployment or development automation

## Nginx Reload vs Restart

**Reload (when running):**
- ✅ Zero downtime
- ✅ Applies new configuration
- ✅ Maintains existing connections
- ✅ Faster operation

**Start (when not running):**
- Initializes nginx with configuration
- Starts listening on configured ports
- Loads all modules and settings

## Common Configuration Locations

**Windows:**
```bash
nginx_base="/c/nginx"
nginx_base="/c/tools/nginx"
nginx_base="/c/Program Files/nginx"
```

**Linux (adapted):**
```bash
nginx_base="/usr/local/nginx"
nginx_base="/etc/nginx"
nginx_base="/opt/nginx"
```

## Troubleshooting

**Script doesn't work:**
1. Verify `nginx_base` path is correct
2. Check nginx installation and permissions
3. Ensure PowerShell is available
4. Verify nginx configuration file exists

**Nginx fails to start:**
1. Check nginx configuration syntax: `nginx -t`
2. Verify port conflicts
3. Check file permissions
4. Review nginx error logs

## Notes

- The script opens PowerShell in non-exit mode (`-NoExit`) for debugging
- Requires Windows environment with PowerShell
- Configuration file path is specified explicitly
- Process detection uses the full nginx executable path
- No output validation - check nginx logs for errors