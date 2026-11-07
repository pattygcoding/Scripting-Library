# timer - Measures how long a command takes to run.
#
# Named "timer" (not "time") because "time" is a reserved word in bash.
timer() {
    if [[ $# -eq 0 ]]; then
        echo -e "\033[31mtimer: you must pass a command to time.\033[0m" >&2
        return 1
    fi

    local start end elapsed
    start=$(date +%s.%N)
    "$@"
    local exit_code=$?
    end=$(date +%s.%N)

    if command -v bc >/dev/null 2>&1; then
        elapsed=$(echo "$end - $start" | bc)
    else
        elapsed=$(awk "BEGIN { printf \"%.6f\", $end - $start }")
    fi

    echo -e "\n\033[35mThe task took ${elapsed} seconds to complete.\033[0m\n"
    return $exit_code
}
