# dotnet-analysis - Summarizes DbCommands, actions, action methods and endpoints from a .NET log.
dotnet-analysis() {
    local file="${1:-TestFile1.txt}"
    if [[ ! -f "$file" ]]; then
        echo -e "\033[31mFile not found: $file\033[0m" >&2
        return 1
    fi

    local line_number=1
    local current_db=""
    local current_start=""
    local db_lines=() action_methods=() actions=() endpoints=()

    local line
    while IFS= read -r line; do
        if [[ "$line" == *"Executed action method"* ]]; then
            action_methods+=("$line_number $line")
        elif [[ "$line" == *"Executed action"* ]]; then
            actions+=("$line_number $line")
        elif [[ "$line" == *"Executed endpoint"* ]]; then
            endpoints+=("$line_number $line")
        elif [[ "$line" == *"Executed DbCommand"* ]]; then
            if [[ -n "$current_db" ]]; then
                db_lines+=("$(process-db-block "$current_db" "$current_start")")
            fi
            current_db="$line"
            current_start="$line_number"
        elif [[ -n "$current_db" ]]; then
            current_db+=$'\n'"$line"
        fi
        ((line_number++))
    done < "$file"

    if [[ -n "$current_db" ]]; then
        db_lines+=("$(process-db-block "$current_db" "$current_start")")
    fi

    local grouped
    grouped=$(group-db-lines "${db_lines[@]}")

    echo -e "\n\033[36m--- Executed DbCommands ---\033[0m"
    echo -e "\033[33m$grouped\033[0m"

    echo -e "\n\033[36m--- Executed Action Methods ---\033[0m"
    printf '\033[33m%s\033[0m\n' "${action_methods[@]}"

    echo -e "\n\033[36m--- Executed Actions ---\033[0m"
    printf '\033[33m%s\033[0m\n' "${actions[@]}"

    echo -e "\n\033[36m--- Executed Endpoints ---\033[0m"
    printf '\033[33m%s\033[0m\n' "${endpoints[@]}"
}

process-db-block() {
    local block="$1"
    local line_start="$2"

    local db_name="Unknown DB"
    if [[ "$block" =~ FROM\ \[([A-Za-z0-9_]+)\] ]]; then
        db_name="${BASH_REMATCH[1]}"
    elif [[ "$block" =~ UPDATE\ \[([A-Za-z0-9_]+)\] ]]; then
        db_name="${BASH_REMATCH[1]}"
    fi

    local joins=()
    while [[ "$block" =~ JOIN\ \[([A-Za-z0-9_]+)\] ]]; do
        joins+=("${BASH_REMATCH[1]}")
        block="${block//${BASH_REMATCH[0]}/}"
    done

    if (( ${#joins[@]} > 0 )); then
        local join_string
        join_string=$(IFS=,; echo "${joins[*]}")
        echo "$line_start [INF] Executed DbCommand from DB [$db_name] with joins: [$join_string]"
    else
        echo "$line_start [INF] Executed DbCommand from DB [$db_name]"
    fi
}

group-db-lines() {
    local grouped=()
    local prev_info=""
    local current_group=""
    local line number info
    for line in "$@"; do
        number="${line%% *}"
        info="${line#* }"
        if [[ "$info" == "$prev_info" ]]; then
            current_group+=", $number"
        else
            [[ -n "$current_group" ]] && grouped+=("$current_group $prev_info")
            current_group="$number"
            prev_info="$info"
        fi
    done
    [[ -n "$current_group" ]] && grouped+=("$current_group $prev_info")
    printf '%s\n' "${grouped[@]}"
}
