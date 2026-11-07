# undo-commit - Undoes the last commit and force-pushes the rewrite.
undo-commit() {
    local mode="${1:-hard}"

    if [[ "$mode" != "hard" && "$mode" != "mixed" && "$mode" != "soft" ]]; then
        echo -e "\033[31mundo-commit: invalid mode. Use 'hard', 'mixed', or 'soft'.\033[0m" >&2
        return 1
    fi

    echo -e "\033[33mundo-commit: Undoing the last commit with --$mode...\033[0m"
    git reset --"$mode" HEAD~1

    echo -e "\033[33mundo-commit: Pushing changes...\033[0m"
    git push --force

    echo -e "\033[32mundo-commit: Undo last commit complete.\033[0m"
}
