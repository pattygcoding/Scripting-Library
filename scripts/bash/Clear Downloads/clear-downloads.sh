# clear-downloads - Deletes everything inside the current user's Downloads folder.
clear-downloads() {
    local directory="${1:-$HOME/Downloads}"

    if [[ ! -d "$directory" ]]; then
        echo -e "\033[31mclear-downloads: folder not found: $directory\033[0m" >&2
        return 1
    fi

    echo -e "\033[33mDeleting all contents in $directory...\033[0m"
    find "$directory" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    echo -e "\033[32mDownloads folder cleared permanently.\033[0m"
}
