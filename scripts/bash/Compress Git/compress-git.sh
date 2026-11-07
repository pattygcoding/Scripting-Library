# compress-git - Squashes the current branch into a single commit.
compress-git() {
    local message="$1"

    if [[ -z "$message" ]]; then
        echo -e "\033[31mcompress-git: commit message required.\033[0m" >&2
        echo "Usage: compress-git \"Your commit message here\""
        return 1
    fi

    echo -e "\033[33mcompress-git: Fetching...\033[0m"
    git fetch

    echo -e "\033[33mcompress-git: Staging changes for compression...\033[0m"
    git reset --soft origin/main

    echo -e "\033[33mcompress-git: Committing changes...\033[0m"
    git commit -m "$message"

    echo -e "\033[33mcompress-git: Pushing changes...\033[0m"
    git push --force

    echo -e "\033[32mcompress-git: Compress git complete.\033[0m"
}
