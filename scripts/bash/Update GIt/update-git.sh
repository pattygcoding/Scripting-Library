# update-git - Fetches and merges the latest changes into the current Git branch.
update-git() {
    local branch="$1"
    local target="${branch:-master}"
    local merge_branch="origin/$target"

    echo -e "\033[33mupdate-git: Fetching...\033[0m"
    git fetch

    local message="Auto-merge update: Merged $target to branch using update-git Bash function (git fetch; git merge $merge_branch; git push;)"
    echo -e "\033[33mupdate-git: Merging $merge_branch into the current branch...\033[0m"
    git merge "$merge_branch" -m "$message"

    echo -e "\033[33mupdate-git: Pushing changes...\033[0m"
    git push

    echo -e "\033[32mupdate-git: Auto-merge complete. Your branch is now up to date with $target.\033[0m"
}
