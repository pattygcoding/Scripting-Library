<#
.SYNOPSIS
    Hard-resets the current branch to origin/main.

.DESCRIPTION
    Fetches the latest changes, hard-resets the branch to origin/main (discarding
    all local changes), and force-pushes. This is destructive.

.EXAMPLE
    Reset-Git
#>
function Reset-Git {
    [CmdletBinding()]
    param ()

    Write-Host 'reset-git: Fetching...' -ForegroundColor Yellow
    git fetch

    Write-Host 'reset-git: Resetting branch to original state...' -ForegroundColor Yellow
    git reset --hard origin/main

    Write-Host 'reset-git: Pushing changes...' -ForegroundColor Yellow
    git push --force

    Write-Host 'reset-git: Reset git complete.' -ForegroundColor Green
}
