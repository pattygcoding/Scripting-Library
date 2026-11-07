# count-files - Counts files in the current directory tree, grouped by extension.
count-files() {
    local include_node=false
    local arg
    for arg in "$@"; do
        [[ "$arg" == "--includenode" ]] && include_node=true
    done

    local files=()
    local f
    while IFS= read -r -d '' f; do
        if ! $include_node && [[ "$f" == *"/node_modules/"* ]]; then
            continue
        fi
        files+=("$f")
    done < <(find . -type f -print0)

    declare -A counts=()
    local base ext
    for f in "${files[@]}"; do
        base="${f##*/}"
        ext=""
        [[ "$base" == *.* ]] && ext=".${base##*.}"
        counts["$ext"]=$(( ${counts["$ext"]:-0} + 1 ))
    done

    echo -e "\033[96mTotal number of files: \033[0m\033[93m${#files[@]}\033[0m"
    echo -e "\033[96mFiles by extension:\033[0m"

    if [[ ${#counts[@]} -gt 0 ]]; then
        local key
        while IFS= read -r key; do
            echo -e "\033[93m${key}: ${counts[$key]}\033[0m"
        done < <(printf '%s\n' "${!counts[@]}" | sort)
    fi
}
