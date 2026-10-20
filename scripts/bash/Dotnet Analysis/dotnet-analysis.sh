dotnet-analysis() {
    local file="${1:-TestFile1.txt}"
    [[ ! -f "$file" ]] && echo -e "\033[31mFile not found: $file\033[0m" && return 1

    local lineNumber=1
    local currentDbCommand=""
    local currentLineStart=""
    local dbCommandLines=()
    local actionMethodLines=()
    local actionLines=()
    local endpointLines=()

    # Process and classify lines
    while IFS= read -r line; do
        if [[ "$line" == *"Executed action method"* ]]; then
            actionMethodLines+=("$lineNumber $line")
        elif [[ "$line" == *"Executed action"* ]]; then
            actionLines+=("$lineNumber $line")
        elif [[ "$line" == *"Executed endpoint"* ]]; then
            endpointLines+=("$lineNumber $line")
        elif [[ "$line" == *"Executed DbCommand"* ]]; then
            if [[ -n "$currentDbCommand" ]]; then
                dbCommandLines+=("$(process-db-block "$currentDbCommand" "$currentLineStart")")
            fi
            currentDbCommand="$line"
            currentLineStart="$lineNumber"
        elif [[ -n "$currentDbCommand" ]]; then
            currentDbCommand+="
$line"
        fi
        ((lineNumber++))
    done < "$file"

    # Process final DbCommand block
    if [[ -n "$currentDbCommand" ]]; then
        dbCommandLines+=("$(process-db-block "$currentDbCommand" "$currentLineStart")")
    fi

    # Sort and group
    IFS=$'\n' sortedDb=($(sort -n <<<"${dbCommandLines[*]}"))
    groupedDb=($(group-db-lines "${sortedDb[@]}"))

    IFS=$'\n' actionMethodLines=($(sort -n <<<"${actionMethodLines[*]}"))
    IFS=$'\n' actionLines=($(sort -n <<<"${actionLines[*]}"))
    IFS=$'\n' endpointLines=($(sort -n <<<"${endpointLines[*]}"))

    echo -e "\n\033[36m--- Executed DbCommands ---\033[0m"
    for line in "${groupedDb[@]}"; do echo -e "\033[33m$line\033[0m"; done

    echo -e "\n\033[36m--- Executed Action Methods ---\033[0m"
    for line in "${actionMethodLines[@]}"; do echo -e "\033[33m$line\033[0m"; done

    echo -e "\n\033[36m--- Executed Actions ---\033[0m"
    for line in "${actionLines[@]}"; do echo -e "\033[33m$line\033[0m"; done

    echo -e "\n\033[36m--- Executed Endpoints ---\033[0m"
    for line in "${endpointLines[@]}"; do echo -e "\033[33m$line\033[0m"; done
}

process-db-block() {
    local block="$1"
    local lineStart="$2"

    local dbName="Unknown DB"
    if [[ "$block" =~ FROM\ \[([A-Za-z0-9_]+)\] ]]; then
        dbName="${BASH_REMATCH[1]}"
    elif [[ "$block" =~ UPDATE\ \[([A-Za-z0-9_]+)\] ]]; then
        dbName="${BASH_REMATCH[1]}"
    fi

    local joins=()
    while [[ "$block" =~ JOIN\ \[([A-Za-z0-9_]+)\] ]]; do
        joins+=("${BASH_REMATCH[1]}")
        block="${block/${BASH_REMATCH[0]}/}" # Remove to find next
    done

    if (( ${#joins[@]} > 0 )); then
        local joinString
        joinString=$(IFS=, ; echo "${joins[*]}")
        echo "$lineStart [INF] Executed DbCommand from DB [$dbName] with joins: [$joinString]"
    else
        echo "$lineStart [INF] Executed DbCommand from DB [$dbName]"
    fi
}

group-db-lines() {
    local grouped=()
    local prevInfo=""
    local currentGroup=""
    for line in "$@"; do
        local number="${line%% *}"
        local info="${line#* }"
        if [[ "$info" == "$prevInfo" ]]; then
            currentGroup+=", $number"
        else
            [[ -n "$currentGroup" ]] && grouped+=("$currentGroup $prevInfo")
            currentGroup="$number"
            prevInfo="$info"
        fi
    done
    [[ -n "$currentGroup" ]] && grouped+=("$currentGroup $prevInfo")
    echo "${grouped[@]}"
}
