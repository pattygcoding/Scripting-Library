# print - Prints text with optional ANSI color.
print() {
    local -A colors=(
        [black]=30
        [red]=91
        [green]=92
        [yellow]=93
        [blue]=94
        [magenta]=95
        [cyan]=96
        [white]=97
    )

    local color=""
    local newline=true
    local message=()
    local i=1 arg
    while [[ $i -le $# ]]; do
        arg="${!i}"
        if [[ "$arg" == "--color" ]]; then
            i=$((i + 1))
            color="${!i}"
        elif [[ "$arg" == "--no-newline" ]]; then
            newline=false
        else
            message+=("$arg")
        fi
        i=$((i + 1))
    done

    local text="${message[*]}"
    if [[ -n "$color" && -n "${colors[$color]}" ]]; then
        printf '\033[%sm%s\033[0m' "${colors[$color]}" "$text"
    else
        printf '%s' "$text"
    fi
    $newline && printf '\n'
}
