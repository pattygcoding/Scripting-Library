react-start() {
    local port=3000
    echo -e "\033[33mStarting React app on port $port...\033[0m"
    (npm start &)
    sleep 2
    xdg-open "http://localhost:$port" > /dev/null 2>&1 || open "http://localhost:$port"
}
