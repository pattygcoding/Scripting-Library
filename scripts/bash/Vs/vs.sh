function vs() {
    file_name="$1"
    index_file="$2"

    if [ -z "$file_name" ]; then
        echo "Please provide a file name." >&2
        return 1
    fi

    base=$(basename "$file_name" | sed 's/\.[^.]*$//')
    ext="${file_name##*.}"
    if [[ "$file_name" == "$ext" ]]; then
        search_file="${base}.cs"
    else
        search_file="$file_name"
    fi

    declare -A vs_index

    if [ -f "$index_file" ]; then
        while IFS='|' read -r key dirs; do
            IFS=';' read -ra dir_array <<< "$dirs"
            vs_index["$key"]="${dir_array[@]}"
        done < "$index_file"

        if [[ -n "${vs_index[$base]}" ]]; then
            found_paths=()
            for dir in ${vs_index[$base]}; do
                full_path="$dir/$search_file"
                if [ -f "$full_path" ]; then
                    found_paths+=("$full_path")
                fi
            done

            if [ ${#found_paths[@]} -gt 0 ]; then
                for path in "${found_paths[@]}"; do
                    powershell.exe -Command "Write-Host 'Opened (cache): $path' -ForegroundColor Yellow"
                done
                powershell.exe -Command "devenv.exe /Edit $(printf '"%s" ' "${found_paths[@]}")"
                return 0
            fi
        fi
    fi

    excludes=("bin" "obj" ".git" "node_modules")
    matches=()

    while IFS= read -r -d '' f; do
        skip=0
        for ex in "${excludes[@]}"; do
            if [[ "$f" == *"/$ex/"* ]]; then
                skip=1
                break
            fi
        done
        if [ $skip -eq 0 ]; then
            matches+=("$f")
        fi
    done < <(find . -type f -name "$search_file" -print0)

    if [ ${#matches[@]} -eq 0 ]; then
        echo "No instances of '$search_file' found under '$PWD'." >&2
        return 1
    fi

    for path in "${matches[@]}"; do
        powershell.exe -Command "Write-Host 'Opened (fs): $path' -ForegroundColor Yellow"
    done
    powershell.exe -Command "devenv.exe /Edit $(printf '"%s" ' "${matches[@]}")"
}
