<#
.SYNOPSIS
    Rebases every local branch onto its upstream.

.DESCRIPTION
    Iterates over all local branches, checks each one out, and runs rebase-git
    on it. Stops if a rebase fails so conflicts can be resolved manually.

.EXAMPLE
    rebase-git-all
#>
function rebase-git-all {
    [CmdletBinding()]
    param ()

    $branches = git branch | ForEach-Object {
        $_.TrimStart('*').Trim()
    }

    if ($branches.Count -eq 0) {
        Write-Host 'No branches found in the repository.' -ForegroundColor Red
        return
    }

    foreach ($branch in $branches) {
        git checkout $branch | Out-Null
        Write-Host "Currently on branch: $branch" -ForegroundColor Blue

        try {
            rebase-git
        }
        catch {
            Write-Host "Rebase failed on branch '$branch'. Resolve manually and continue." -ForegroundColor Red
            return
        }
    }

    Write-Host 'Finished rebasing all branches onto their upstreams.' -ForegroundColor Green
}
