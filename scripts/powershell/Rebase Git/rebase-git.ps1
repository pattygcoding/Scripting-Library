<#
.SYNOPSIS
    Rebases the current branch onto origin/master or a given branch.

.DESCRIPTION
    Fetches the latest changes, rebases the current branch onto origin/<branch>,
    and force-pushes with lease. Keeps a linear history with no merge commit.

.PARAMETER branch
    The branch to rebase onto. Defaults to "master".

.EXAMPLE
    rebase-git
    rebase-git -branch "main"
#>
function rebase-git {
    [CmdletBinding()]
    param (
        [string]$branch
    )

    Write-Host 'rebase-git: Fetching latest changes...' -ForegroundColor Yellow
    git fetch

    if ($branch) {
        $rebaseBranch = "origin/$branch"
        Write-Host "rebase-git: Rebasing onto $rebaseBranch..." -ForegroundColor Yellow
    }
    else {
        $rebaseBranch = 'origin/master'
        Write-Host 'rebase-git: Rebasing onto origin/master...' -ForegroundColor Yellow
    }

    git rebase $rebaseBranch

    if ($LASTEXITCODE -ne 0) {
        Write-Host "rebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually." -ForegroundColor Red
        return
    }

    Write-Host 'rebase-git: Rebase successful. Pushing rebased changes...' -ForegroundColor Yellow
    git push --force-with-lease

    if ($branch) {
        Write-Host "rebase-git: Rebase complete. Your branch is now up to date with $branch (no merge commit)." -ForegroundColor Green
    }
    else {
        Write-Host 'rebase-git: Rebase complete. Your branch is now up to date with master (no merge commit).' -ForegroundColor Green
    }
}
