safe-unzip() {
    local zip_path="$1"
    local max_file_count="${2:-1000}"
    local max_total_size_bytes="${3:-524288000}" # 500MB

    if [[ -z "$zip_path" ]]; then
        echo "Usage: safe-unzip <zip-path> [max-files] [max-bytes]"
        return 1
    fi

    if [[ ! -f "$zip_path" ]]; then
        echo -e "\033[31mError: Zip file not found: $zip_path\033[0m"
        return 1
    fi

    local dest_dir="${zip_path%.*}_unzipped"
    mkdir -p "$dest_dir"

    local entry_count=0
    local total_size=0

    while IFS= read -r line; do
        # Skip empty or malformed lines
        [[ -z "$line" ]] && continue

        # Get file size and path
        local size path
        size=$(echo "$line" | awk '{print $1}')
        path=$(echo "$line" | cut -d' ' -f5-)

        # Security check: avoid zip slip
        if [[ "$path" =~ (^|/)\.\.(/|$) ]]; then
            echo -e "\033[31mAborted: Unsafe path detected: $path\033[0m"
            return 1
        fi

        ((entry_count++))
        ((total_size+=size))

        if (( entry_count > max_file_count )); then
            echo -e "\033[31mAborted: File count exceeds limit of $max_file_count\033[0m"
            return 1
        fi

        if (( total_size > max_total_size_bytes )); then
            echo -e "\033[31mAborted: Total uncompressed size exceeds $((max_total_size_bytes / 1048576)) MB\033[0m"
            return 1
        fi
    done < <(zipinfo -l "$zip_path" | awk 'NR>3 && NF>=5 {print $1, $NF}' | grep -v '/$')

    unzip -q "$zip_path" -d "$dest_dir"
    echo -e "\033[32mExtracted to: $dest_dir\033[0m"
}
