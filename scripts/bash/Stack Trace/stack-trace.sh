# stack-trace - Extracts the relative file paths from a .NET stack trace.
stack-trace() {
    local file="${1:-test.txt}"
    if [[ ! -f "$file" ]]; then
        echo "stack-trace: file not found: $file" >&2
        return 1
    fi

    grep -E '^[[:space:]]*at ' "$file" \
        | grep -vE '^[[:space:]]*at Microsoft' \
        | grep -E ' in ' \
        | sed -E 's/.* in //' \
        | sed -E 's#[\\]+#/#g; s#/+#/#g; s#^[A-Za-z]:/a/1/s/##' \
        | while IFS= read -r rel; do
            echo -e "\033[33m${rel}\033[0m"
        done
}
