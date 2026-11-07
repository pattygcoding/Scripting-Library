# goto - Jumps to a frequently used directory.
#
# Configure the destinations below, then run e.g. `goto repos`.
goto() {
    local target="$1"
    declare -A destinations=(
        [locals]="" # Insert your locals path here
        [repos]=""  # Insert your repos path here
    )

    local key="${target,,}"
    local path="${destinations[$key]}"

    if [[ -z "$target" || -z "$path" ]]; then
        echo "Option '$target' does not exist." >&2
        echo "" >&2
        echo "Available options:" >&2
        for key in "${!destinations[@]}"; do
            printf '  %-8s - %s\n' "$key" "${destinations[$key]}" >&2
        done
        return 1
    fi

    cd "$path" || return 1
    echo "Navigated to $path"
}
