# neovim - Finds files by name and opens each match in Neovim.
neovim() {
    local name="$1"
    if [[ -z "$name" ]]; then
        echo "Usage: neovim <file-name>" >&2
        return 1
    fi

    local matches=()
    local f
    while IFS= read -r -d '' f; do
        [[ "${f##*/}" == "$name" ]] && matches+=("$f")
    done < <(find . -type f -print0)

    if [[ ${#matches[@]} -eq 0 ]]; then
        echo -e "\033[31mneovim: no instances of '$name' found.\033[0m" >&2
        return 1
    fi

    local path
    for path in "${matches[@]}"; do
        echo -e "\033[33mOpening $path in nvim\033[0m"
        nvim "$path"
    done
}
