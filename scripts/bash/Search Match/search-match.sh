# search-match - Searches files of a given extension for one or more terms.
search-match() {
    local max_results=3000
    local uncapped=false cross=false show_dir=false calls=false
    local extension=""
    local terms=()

    local arg
    for arg in "$@"; do
        case "$arg" in
            --uncapped) uncapped=true ;;
            --cross) cross=true ;;
            --dir) show_dir=true ;;
            --calls) calls=true ;;
            *)
                if [[ -z "$extension" ]]; then
                    extension="$arg"
                else
                    terms+=("$arg")
                fi
                ;;
        esac
    done

    if [[ -z "$extension" || ${#terms[@]} -eq 0 ]]; then
        echo "Usage: search-match <extension> <term> [term...] [--uncapped] [--cross] [--dir] [--calls]" >&2
        return 1
    fi
    [[ "$extension" == .* ]] || extension=".$extension"

    local files=()
    local f
    while IFS= read -r -d '' f; do
        [[ "$f" == *"$extension" ]] && files+=("$f")
    done < <(find . -type f -print0)
    mapfile -t files < <(printf '%s\n' "${files[@]}" | sort)

    local results=0 printed
    local file line line_number term trimmed
    for file in "${files[@]}"; do
        [[ $uncapped == false && $results -ge $max_results ]] && break

        printed=false
        line_number=0
        declare -A term_hits=()

        while IFS= read -r line; do
            ((line_number++))
            trimmed="${line#"${line%%[![:space:]]*}"}"

            for term in "${terms[@]}"; do
                [[ "$line" != *"$term"* ]] && continue
                [[ $calls == true && "$line" != *".$term"* ]] && continue

                if $cross; then
                    term_hits["$term"]+="${line_number}"$'\t'"${trimmed}"$'\n'
                else
                    if ! $printed; then
                        [[ $show_dir == true ]] && echo "$file" || echo "${file##*/}"
                        printed=true
                    fi
                    echo -e "${line_number}\t${trimmed}"
                    ((results++))
                    [[ $uncapped == false && $results -ge $max_results ]] && break
                fi
            done
            [[ $uncapped == false && $results -ge $max_results ]] && break
        done < "$file"

        if $cross; then
            local all=1 t
            for t in "${terms[@]}"; do
                [[ -z "${term_hits[$t]}" ]] && all=0
            done
            if [[ $all -eq 1 ]]; then
                [[ $show_dir == true ]] && echo "$file" || echo "${file##*/}"
                local t2
                for t2 in "${terms[@]}"; do
                    printf '%s' "${term_hits[$t2]}"
                done
                ((results++))
            fi
        fi
    done
}
