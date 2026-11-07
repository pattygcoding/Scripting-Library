<#
.SYNOPSIS
    Squashes the current branch into a single commit.

.DESCRIPTION
    Fetches the latest changes, soft-resets to origin/main so all of the branch's
    changes are staged, commits them as one, and force-pushes the result.

.PARAMETER message
    The commit message for the squashed commit. Required.

.EXAMPLE
    Compress-Git -message "Feature implementation"
#>
function Compress-Git {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$message
    )

    Write-Host 'compress-git: Fetching...' -ForegroundColor Yellow
    git fetch

    Write-Host 'compress-git: Staging changes for compression...' -ForegroundColor Yellow
    git reset --soft origin/main

    Write-Host 'compress-git: Committing changes...' -ForegroundColor Yellow
    git commit -m $message

    Write-Host 'compress-git: Pushing changes...' -ForegroundColor Yellow
    git push --force

    Write-Host 'compress-git: Compress git complete.' -ForegroundColor Green
}
