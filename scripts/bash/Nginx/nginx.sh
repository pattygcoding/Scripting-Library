function nginx() {
    nginx_base= # Insert path to nginx setup here
    nginx_exe="$nginx_base/nginx.exe"
    nginx_conf="$nginx_base/conf/nginx.conf"

    # Check if nginx is running
    if pgrep -f "$nginx_exe" > /dev/null; then
        # Reload nginx if running
        powershell.exe -NoExit -Command "& '$nginx_exe' -s reload"
    else
        # Start nginx with specified config if not running
        powershell.exe -NoExit -Command "& '$nginx_exe' -c '$nginx_conf'"
    fi
}
