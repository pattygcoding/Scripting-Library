# create-file - Creates a new file, defaulting to a .txt extension.
create-file() {
    local name="$1"

    if [[ -z "$name" ]]; then
        echo "Usage: create-file <filename>" >&2
        return 1
    fi

    if [[ "$name" != *.* ]]; then
        name="${name}.txt"
    fi

    touch -- "$name"
    echo "Created $name"
}
