# compare-diff - Compares two text files line by line and highlights the differences.
compare-diff() {
    local f1="TestFile1.txt"
    local f2="TestFile2.txt"
    local notime=false

    local positional=()
    local arg
    for arg in "$@"; do
        if [[ "$arg" == "--notime" ]]; then
            notime=true
        else
            positional+=("$arg")
        fi
    done
    [[ ${#positional[@]} -ge 1 ]] && f1="${positional[0]}"
    [[ ${#positional[@]} -ge 2 ]] && f2="${positional[1]}"

    if [[ ! -f "$f1" || ! -f "$f2" ]]; then
        echo -e "\033[31mcompare-diff: one or both files not found.\033[0m" >&2
        return 1
    fi

    echo -e "\n\033[31mRED   = $f1\033[0m"
    echo -e   "\033[32mGREEN = $f2\033[0m\n"

    local tmp1 tmp2
    tmp1=$(mktemp)
    tmp2=$(mktemp)

    if $notime; then
        echo -e "\033[33mcompare-diff: --notime set. Timestamps will not be compared.\033[0m"
        sed -E 's/\[[0-9]{2}:[0-9]{2}:[0-9]{2} [AP]M\]|\([0-9]+ms\)//g' "$f1" > "$tmp1"
        sed -E 's/\[[0-9]{2}:[0-9]{2}:[0-9]{2} [AP]M\]|\([0-9]+ms\)//g' "$f2" > "$tmp2"
    else
        cp "$f1" "$tmp1"
        cp "$f2" "$tmp2"
    fi

    diff --unchanged-line-format= \
        --old-line-format=$'\033[31m- %L\033[0m' \
        --new-line-format=$'\033[32m+ %L\033[0m' \
        "$tmp1" "$tmp2"

    local status=$?
    rm -f "$tmp1" "$tmp2"
    return $status
}
