# react-start - Starts a React development server and opens it in the browser.
react-start() {
    local port="${1:-3000}"
    local command="${2:-npm start}"

    echo -e "\033[33mreact-start: starting on port $port...\033[0m"
    ($command &)
    sleep 2

    xdg-open "http://localhost:$port" >/dev/null 2>&1 \
        || open "http://localhost:$port" >/dev/null 2>&1 \
        || start "http://localhost:$port" >/dev/null 2>&1
}
