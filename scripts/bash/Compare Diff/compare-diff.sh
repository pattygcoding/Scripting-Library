compare-diff() {
    local f1="${1:-TestFile1.txt}"
    local f2="${2:-TestFile2.txt}"
    local notime=false

    if [[ "$3" == "--notime" ]]; then
        notime=true
        echo -e "\033[33mNote: --notime flag set. Timestamps will not be compared or displayed.\033[0m"
    fi

    echo -e "\n\033[31mRED   = $f1\033[0m"
    echo -e   "\033[32mGREEN = $f2\033[0m\n"

    # Check if files exist
    if [[ ! -f "$f1" || ! -f "$f2" ]]; then
        echo -e "\033[31mError: One or both files not found.\033[0m"
        return 1
    fi

    # Remove timestamps if --notime is set
    if $notime; then
        # Pattern: [HH:MM:SS AM/PM] and (###ms)
        clean1=$(sed -E 's/\[[0-9]{2}:[0-9]{2}:[0-9]{2} [AP]M\]|\([0-9]+ms\)//g' "$f1")
        clean2=$(sed -E 's/\[[0-9]{2}:[0-9]{2}:[0-9]{2} [AP]M\]|\([0-9]+ms\)//g' "$f2")
    else
        clean1=$(cat "$f1")
        clean2=$(cat "$f2")
    fi

    # Save cleaned content to temp files
    tmp1=$(mktemp)
    tmp2=$(mktemp)
    echo "$clean1" > "$tmp1"
    echo "$clean2" > "$tmp2"

    # Run diff and colorize output
    diff --unchanged-line-format= --old-line-format=$'\033[31m- %L\033[0m' --new-line-format=$'\033[32m+ %L\033[0m' "$tmp1" "$tmp2"

    # Cleanup
    rm -f "$tmp1" "$tmp2"
}
