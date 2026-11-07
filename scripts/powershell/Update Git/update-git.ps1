<#
.SYNOPSIS
    Fetches and merges the latest changes into the current branch.

.DESCRIPTION
    Fetches from the remote, merges origin/<branch> into the current branch, and
    pushes. Merges origin/master when no branch is specified.

.PARAMETER branch
    The branch to merge into the current branch. Defaults to "master".

.EXAMPLE
    update-git
    update-git -branch "main"
#>
function update-git {
    [CmdletBinding()]
    param (
        [string]$branch
    )

    Write-Host 'update-git: Fetching...' -ForegroundColor Yellow
    git fetch

    if ($branch) {
        $mergeBranch = "origin/$branch"
        $source = $branch
    }
    else {
        $mergeBranch = 'origin/master'
        $source = 'master'
    }

    $message = "Auto-merge update: Merged $source to branch using update-git PowerShell alias (git fetch; git merge $mergeBranch; git push;)"

    Write-Host "update-git: Merging $mergeBranch into the current branch..." -ForegroundColor Yellow
    git merge $mergeBranch -m "$message"

    Write-Host 'update-git: Pushing changes...' -ForegroundColor Yellow
    git push

    Write-Host "update-git: Auto-merge complete. Your branch is now up to date with $source." -ForegroundColor Green
}
