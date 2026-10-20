function update-git() {
    local branch="$1"

    echo -e "\e[33mupdate-git: Fetching...\e[0m"
    git fetch

    if [[ -n "$branch" ]]; then
        local merge_branch="origin/$branch"
        local message="Auto-merge update: Merged $branch to branch using update-git Bash function (git fetch; git merge $merge_branch; git push;)"
        echo -e "\e[33mupdate-git: Merging $merge_branch into the current branch...\e[0m"
    else
        local merge_branch="origin/master"
        local message="Auto-merge update: Merged master to branch using update-git Bash function (git fetch; git merge $merge_branch; git push;)"
        echo -e "\e[33mupdate-git: Merging $merge_branch into the current branch...\e[0m"
    fi

    git merge "$merge_branch" -m "$message"
    echo -e "\e[33mupdate-git: Pushing changes...\e[0m"
    git push

    if [[ -n "$branch" ]]; then
        echo -e "\e[32mupdate-git: Auto-merge complete. Your branch is now up to date with $branch.\e[0m"
    else
        echo -e "\e[32mupdate-git: Auto-merge complete. Your branch is now up to date with master.\e[0m"
    fi
}
