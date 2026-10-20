vue-start() {
    local port=5173
    echo -e "\033[33mStarting Vue app on port $port...\033[0m"
    (npm run dev &)
    sleep 2
    xdg-open "http://localhost:$port" > /dev/null 2>&1 || open "http://localhost:$port"
}
