# gensql-count - Generates a SQL script to count the entries in a table.
gensql-count() {
    local table="$1"

    if [[ -z "$table" ]]; then
        echo "Usage: gensql-count <table>" >&2
        return 1
    fi

    echo -e "\033[35mSELECT COUNT(*) AS total_entries\nFROM ${table};\n\033[0m"
}
