# vsc - Finds a file by name and opens it in Visual Studio Code.
vsc() {
    local name="$1"
    if [[ -z "$name" ]]; then
        echo "Usage: vsc <file-name>" >&2
        return 1
    fi

    local matches=()
    local f
    while IFS= read -r -d '' f; do
        [[ "${f##*/}" == "$name" ]] && matches+=("$f")
    done < <(find . -type f -print0)

    if [[ ${#matches[@]} -eq 0 ]]; then
        echo -e "\033[31mvsc: no instances of '$name' found.\033[0m" >&2
        return 1
    fi

    local path
    for path in "${matches[@]}"; do
        echo -e "\033[33mOpening $path in VS Code\033[0m"
        code "$path"
    done
}
