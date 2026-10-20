function update-git {
    # Example usage:
    # update-git                       # Merges master into the current branch
    # update-git -branch "Hello" # Merges Hello into the current branch

    param (
        [string]$branch
    )
    
    Write-Host("update-git: Fetching...") -ForegroundColor Yellow

    # Fetch the latest changes
    git fetch

    # Determine the branch to merge based on the parameters
    if ($branch) {
        $mergeBranch = "origin/$branch"
        $message = "Auto-merge update: Merged $branch to branch using update-git PowerShell alias (git fetch; git merge $mergeBranch; git push;)"
        Write-Host("update-git: Merging $mergeBranch into the current branch...") -ForegroundColor Yellow
    } else {
        $mergeBranch = "origin/master"
        $message = "Auto-merge update: Merged master to branch using update-git PowerShell alias (git fetch; git merge $mergeBranch; git push;)"
        Write-Host("update-git: Merging $mergeBranch into the current branch...") -ForegroundColor Yellow
    }

    # Merge the selected branch
    git merge $mergeBranch -m "$message"

    Write-Host ("update-git: Pushing changes...") -ForegroundColor Yellow
    # Push the changes
    git push

    # Output completion message
    if ($branch) {
        Write-Host("update-git: Auto-merge complete. Your branch is now up to date with $branch.") -ForegroundColor Green
    } else {
        Write-Host("update-git: Auto-merge complete. Your branch is now up to date with master.") -ForegroundColor Green
    }
}
