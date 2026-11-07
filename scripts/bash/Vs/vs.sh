# vs - Finds a file by name and opens it in Visual Studio.
vs() {
    local file_name="$1"
    local index_file="$2"

    if [[ -z "$file_name" ]]; then
        echo "vs: please provide a file name." >&2
        return 1
    fi

    local base ext search_file
    base=$(basename "$file_name" | sed 's/\.[^.]*$//')
    ext="${file_name##*.}"
    if [[ "$file_name" == "$ext" ]]; then
        search_file="${base}.cs"
    else
        search_file="$file_name"
    fi

    declare -A vs_index=()

    if [[ -f "$index_file" ]]; then
        local key dirs
        while IFS='|' read -r key dirs; do
            [[ -n "$key" ]] && vs_index["$key"]="$dirs"
        done < "$index_file"

        if [[ -n "${vs_index[$base]}" ]]; then
            local found_paths=()
            local dir full_path
            IFS=';' read -ra dir_array <<< "${vs_index[$base]}"
            for dir in "${dir_array[@]}"; do
                full_path="$dir/$search_file"
                [[ -f "$full_path" ]] && found_paths+=("$full_path")
            done

            if [[ ${#found_paths[@]} -gt 0 ]]; then
                local path
                for path in "${found_paths[@]}"; do
                    powershell.exe -Command "Write-Host 'Opened (cache): $path' -ForegroundColor Yellow"
                done
                powershell.exe -Command "devenv.exe /Edit $(printf '\"%s\" ' "${found_paths[@]}")"
                return 0
            fi
        fi
    fi

    local excludes=("bin" "obj" ".git" "node_modules")
    local matches=()
    local f skip ex
    while IFS= read -r -d '' f; do
        skip=0
        for ex in "${excludes[@]}"; do
            if [[ "$f" == *"/$ex/"* ]]; then
                skip=1
                break
            fi
        done
        [[ $skip -eq 0 ]] && matches+=("$f")
    done < <(find . -type f -name "$search_file" -print0)

    if [[ ${#matches[@]} -eq 0 ]]; then
        echo "vs: no instances of '$search_file' found under '$PWD'." >&2
        return 1
    fi

    local path
    for path in "${matches[@]}"; do
        powershell.exe -Command "Write-Host 'Opened (fs): $path' -ForegroundColor Yellow"
    done
    powershell.exe -Command "devenv.exe /Edit $(printf '\"%s\" ' "${matches[@]}")"
}
