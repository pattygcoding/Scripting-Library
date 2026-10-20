clear-git() {
    local orphan_branches
    orphan_branches=$(git branch -vv | awk '$3 !~ /\[origin\// { print $1 }')

    if [[ -z "$orphan_branches" ]]; then
        echo -e "\033[32mclear-git: No local branches without origin found.\033[0m"
        return
    fi

    echo "$orphan_branches" | while read -r branch; do
        echo -e "\033[33mclear-git: Deleting orphan branch: $branch\033[0m"
        git branch -D "$branch"
    done
}
