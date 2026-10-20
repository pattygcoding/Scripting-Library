rebase-git-all() {
    local branches
    mapfile -t branches < <(git for-each-ref --format='%(refname:short)' refs/heads/)

    if [[ ${#branches[@]} -eq 0 ]]; then
        echo -e "\033[31mNo branches found in the repository.\033[0m"
        return
    fi

    for branch in "${branches[@]}"; do
        git checkout "$branch" > /dev/null 2>&1
        echo -e "\033[34mCurrently on branch: $branch\033[0m"

        if ! rebase-git; then
            echo -e "\033[31mRebase failed on branch '$branch'. Resolve manually and continue.\033[0m"
            return 1
        fi
    done

    echo -e "\033[32mFinished rebasing all branches onto their upstreams.\033[0m"
}
