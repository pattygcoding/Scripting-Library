# angular-start - Starts an Angular development server and opens it in the browser.
angular-start() {
    local port="${1:-4200}"
    local command="${2:-ng serve}"

    echo -e "\033[33mangular-start: starting on port $port...\033[0m"
    ($command &)
    sleep 2

    xdg-open "http://localhost:$port" >/dev/null 2>&1 \
        || open "http://localhost:$port" >/dev/null 2>&1 \
        || start "http://localhost:$port" >/dev/null 2>&1
}
