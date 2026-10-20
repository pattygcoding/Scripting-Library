new-branch() {
  local branch="$1"

  if [ -z "$branch" ]; then
    echo -e "\033[1;31mnew-branch: Branch name required.\033[0m"
    echo "Usage: new-branch your-branch-name"
    return 1
  fi

  echo -e "\033[1;33mnew-branch: Fetching...\033[0m"
  git fetch

  echo -e "\033[1;33mnew-branch: Checking out into new branch $branch...\033[0m"
  git checkout -b "$branch" origin/master

  echo -e "\033[1;33mnew-branch: Updating new branch $branch with master...\033[0m"
  git merge origin/master -m "Initial merge"

  echo -e "\033[1;33mnew-branch: Pushing your new branch $branch...\033[0m"
  git push --set-upstream origin "$branch"
}
