india-time() {
    local input="$1"
    local ist_offset="+05:30"

    if [[ -z "$input" ]]; then
        # No input — just show current IST time
        date -u +"Current time in India: %I:%M %p" -d "now $ist_offset"
    elif [[ "$input" =~ ^(0?[1-9]|1[0-2]):[0-5][0-9]\ ?[AaPp][Mm]$ ]]; then
        # Input provided — parse and convert to IST
        local parsed_local
        parsed_local=$(date -d "$input" +"%Y-%m-%d %H:%M:%S" 2>/dev/null)
        if [[ $? -ne 0 ]]; then
            echo -e "\033[31mFailed to parse time.\033[0m"
            return 1
        fi

        # Convert parsed time to UTC, then add IST offset
        local utc_time
        utc_time=$(date -u -d "$parsed_local" +"%Y-%m-%d %H:%M:%S")
        local india_time
        india_time=$(date -d "$utc_time $ist_offset" +"%I:%M %p")

        echo "Inputted time in India: $india_time"
    else
        echo -e "\033[31mInvalid time format. Use format like '8:26 AM'.\033[0m"
    fi
}
