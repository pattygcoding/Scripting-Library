# nginx - Starts or reloads a local Nginx server.
nginx() {
    local nginx_base="${1:-/path/to/nginx}"
    local nginx_exe="$nginx_base/nginx.exe"
    local nginx_conf="$nginx_base/conf/nginx.conf"

    if pgrep -f "$nginx_exe" >/dev/null; then
        powershell.exe -NoExit -Command "& '$nginx_exe' -s reload"
    else
        powershell.exe -NoExit -Command "& '$nginx_exe' -c '$nginx_conf'"
    fi
}
