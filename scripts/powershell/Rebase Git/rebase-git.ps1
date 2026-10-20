function rebase-git {
    param (
        [string]$branch
    )

    Write-Host("rebase-git: Fetching latest changes...") -ForegroundColor Yellow
    git fetch

    if ($branch) {
        $rebaseBranch = "origin/$branch"
        Write-Host("rebase-git: Rebasing onto $rebaseBranch...") -ForegroundColor Yellow
    } else {
        $rebaseBranch = "origin/master"
        Write-Host("rebase-git: Rebasing onto origin/master...") -ForegroundColor Yellow
    }

    git rebase $rebaseBranch

    if ($LASTEXITCODE -ne 0) {
        Write-Host("rebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.") -ForegroundColor Red
        return
    }

    Write-Host("rebase-git: Rebase successful. Pushing rebased changes...") -ForegroundColor Yellow
    git push --force-with-lease

    if ($branch) {
        Write-Host("rebase-git: Rebase complete. Your branch is now up to date with $branch (no merge commit).") -ForegroundColor Green
    } else {
        Write-Host("rebase-git: Rebase complete. Your branch is now up to date with master (no merge commit).") -ForegroundColor Green
    }
}
