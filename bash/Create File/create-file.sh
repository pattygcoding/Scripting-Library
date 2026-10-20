create-file() {
    local name="$1"

    if [[ -z "$name" ]]; then
        echo "Usage: create-file <filename>"
        return 1
    fi

    if [[ "$name" != *.* ]]; then
        name="${name}.txt"
    fi

    : > "$name"
}
