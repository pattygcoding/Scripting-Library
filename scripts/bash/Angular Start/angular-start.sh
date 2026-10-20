angular-start() {
    local port=4200
    echo -e "\033[33mStarting Angular app on port $port...\033[0m"
    (ng serve &)
    sleep 2
    xdg-open "http://localhost:$port" > /dev/null 2>&1 || open "http://localhost:$port"
}
