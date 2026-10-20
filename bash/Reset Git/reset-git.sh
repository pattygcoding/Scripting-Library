reset-git() {
    echo -e "\033[33mreset-git: Fetching...\033[0m"
    git fetch

    echo -e "\033[33mreset-git: Resetting branch to original state...\033[0m"
    git reset --hard origin/main

    echo -e "\033[33mreset-git: Pushing changes...\033[0m"
    git push --force

    echo -e "\033[32mreset-git: Reset git complete.\033[0m"
}
