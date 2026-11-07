# vue-start - Starts a Vue development server and opens it in the browser.
vue-start() {
    local port="${1:-5173}"
    local command="${2:-npm run dev}"

    echo -e "\033[33mvue-start: starting on port $port...\033[0m"
    ($command &)
    sleep 2

    xdg-open "http://localhost:$port" >/dev/null 2>&1 \
        || open "http://localhost:$port" >/dev/null 2>&1 \
        || start "http://localhost:$port" >/dev/null 2>&1
}
