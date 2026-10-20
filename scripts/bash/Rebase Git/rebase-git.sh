rebase-git() {
    local branch="$1"
    echo -e "\033[33mrebase-git: Fetching latest changes...\033[0m"
    git fetch

    if [[ -n "$branch" ]]; then
        local rebase_branch="origin/$branch"
        echo -e "\033[33mrebase-git: Rebasing onto $rebase_branch...\033[0m"
    else
        local rebase_branch="origin/master"
        echo -e "\033[33mrebase-git: Rebasing onto origin/master...\033[0m"
    fi

    git rebase "$rebase_branch"
    local status=$?

    if [[ $status -ne 0 ]]; then
        echo -e "\033[31mrebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.\033[0m"
        return $status
    fi

    echo -e "\033[33mrebase-git: Rebase successful. Pushing rebased changes...\033[0m"
    git push --force-with-lease

    if [[ -n "$branch" ]]; then
        echo -e "\033[32mrebase-git: Rebase complete. Your branch is now up to date with $branch (no merge commit).\033[0m"
    else
        echo -e "\033[32mrebase-git: Rebase complete. Your branch is now up to date with master (no merge commit).\033[0m"
    fi
}
