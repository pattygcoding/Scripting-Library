<#
.SYNOPSIS
    Updates every local branch with the latest changes.

.DESCRIPTION
    Iterates over all local branches, checks each one out, and runs update-git
    so every branch is merged up to date.

.EXAMPLE
    Update-Git-All
#>
function Update-Git-All {
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
        update-git
    }

    Write-Host 'Finished processing all branches.' -ForegroundColor Green
}
