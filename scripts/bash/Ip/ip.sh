# ip - Prints the machine's IPv4 addresses.
ip() {
    local output
    if command -v ipconfig.exe >/dev/null 2>&1; then
        output=$(ipconfig.exe)
    elif command -v ip >/dev/null 2>&1; then
        output=$(ip -4 addr show)
    else
        output=$(ifconfig -a)
    fi

    echo "$output" \
        | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
        | grep -vE '^(255\.|127\.|0\.)' \
        | sort -u
}
