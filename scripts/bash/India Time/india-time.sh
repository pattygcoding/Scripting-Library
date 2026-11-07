# india-time - Converts a time to India Standard Time (IST).
india-time() {
    local input="$1"
    local ist_tz="Asia/Kolkata"

    if [[ -z "$input" ]]; then
        TZ="$ist_tz" date +"Current time in India: %I:%M %p"
    elif [[ "$input" =~ ^(0?[1-9]|1[0-2]):[0-5][0-9]\ ?[AaPp][Mm]$ ]]; then
        local epoch
        if ! epoch=$(date -d "$input" +%s 2>/dev/null); then
            echo -e "\033[31mindia-time: failed to parse time.\033[0m" >&2
            return 1
        fi
        TZ="$ist_tz" date -d "@$epoch" +"Inputted time in India: %I:%M %p"
    else
        echo -e "\033[31mindia-time: invalid time format. Use format like '8:26 AM'.\033[0m" >&2
        return 1
    fi
}
