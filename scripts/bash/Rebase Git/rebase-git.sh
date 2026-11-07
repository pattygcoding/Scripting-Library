# rebase-git - Rebases the current branch onto origin/master or a given branch.
rebase-git() {
    local branch="$1"
    local rebase_branch="origin/master"
    [[ -n "$branch" ]] && rebase_branch="origin/$branch"

    echo -e "\033[33mrebase-git: Fetching latest changes...\033[0m"
    git fetch

    echo -e "\033[33mrebase-git: Rebasing onto $rebase_branch...\033[0m"
    if ! git rebase "$rebase_branch"; then
        echo -e "\033[31mrebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.\033[0m" >&2
        return 1
    fi

    echo -e "\033[33mrebase-git: Rebase successful. Pushing rebased changes...\033[0m"
    git push --force-with-lease

    echo -e "\033[32mrebase-git: Rebase complete. Your branch is now up to date with ${branch:-master} (no merge commit).\033[0m"
}
