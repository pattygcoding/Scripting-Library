# cache-vsindex - Builds and updates an index of .cs files under a directory tree.
cache-vsindex() {
    local root="${1:-$(pwd)}"
    local index_file="$2"

    if [[ -z "$index_file" ]]; then
        echo -e "\033[31mcache-vsindex: an index file path is required.\033[0m" >&2
        echo "Usage: cache-vsindex [root] <index-file>"
        return 1
    fi

    declare -A old_map=()
    declare -A new_map=()

    # Load the existing index: each line is "name|dir1;dir2;...".
    if [[ -f "$index_file" ]]; then
        local key paths
        while IFS='|' read -r key paths; do
            [[ -n "$key" ]] && old_map["$key"]="$paths"
        done < "$index_file"
    fi

    # Collect the directories that hold each .cs base name.
    local file base_name dir_name
    while IFS= read -r -d '' file; do
        base_name=$(basename "$file" .cs)
        dir_name=$(dirname "$file")
        if [[ -n "${new_map[$base_name]}" ]]; then
            new_map["$base_name"]+=";${dir_name}"
        else
            new_map["$base_name"]="$dir_name"
        fi
    done < <(find "$root" -type f -name "*.cs" -print0)

    # Deduplicate and sort each entry's directories.
    local key
    for key in "${!new_map[@]}"; do
        new_map["$key"]=$(printf '%s\n' "${new_map[$key]}" | tr ';' '\n' | sort -u | paste -sd ';' -)
    done

    local added=() removed=() changed=()
    for key in "${!new_map[@]}"; do
        if [[ -z "${old_map[$key]+x}" ]]; then
            added+=("$key")
        elif [[ "${old_map[$key]}" != "${new_map[$key]}" ]]; then
            changed+=("$key")
        fi
    done
    for key in "${!old_map[@]}"; do
        [[ -z "${new_map[$key]+x}" ]] && removed+=("$key")
    done

    if [[ ${#added[@]} -eq 0 && ${#removed[@]} -eq 0 && ${#changed[@]} -eq 0 ]]; then
        echo -e "\033[32mcache-vsindex: no changes detected in .cs files under '$root'.\033[0m"
        return 0
    fi

    # Rewrite the index: keep unchanged entries, then write added/changed ones.
    local tmp_file
    tmp_file=$(mktemp)
    for key in "${!old_map[@]}"; do
        if [[ -n "${new_map[$key]+x}" && "${old_map[$key]}" == "${new_map[$key]}" ]]; then
            echo "$key|${new_map[$key]}"
        fi
    done > "$tmp_file"
    for key in "${added[@]}"; do
        echo "$key|${new_map[$key]}"
    done >> "$tmp_file"
    for key in "${changed[@]}"; do
        echo "$key|${new_map[$key]}"
    done >> "$tmp_file"
    sort -t'|' -k1,1 "$tmp_file" > "$index_file"
    rm -f "$tmp_file"

    echo -e "\033[36mcache-vsindex: index updated: +${#added[@]} / -${#removed[@]} / *${#changed[@]}\033[0m"
}
