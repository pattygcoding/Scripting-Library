# clear-git - Deletes local branches that have no remote (origin) counterpart.
#
# WARNING: branches that were never pushed will be lost.
clear-git() {
    local orphans
    orphans=$(git branch -vv | awk '$3 !~ /\[origin\// { print $1 }')

    if [[ -z "$orphans" ]]; then
        echo -e "\033[32mclear-git: no local branches without origin found.\033[0m"
        return 0
    fi

    local branch
    while read -r branch; do
        echo -e "\033[33mclear-git: deleting orphan branch: $branch\033[0m"
        git branch -D "$branch"
    done <<< "$orphans"
}
