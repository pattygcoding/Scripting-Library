<#
.SYNOPSIS
    Undoes the last commit.

.DESCRIPTION
    Resets the branch back one commit using the requested mode and force-pushes
    the rewrite. "hard" discards the changes, "mixed" keeps them unstaged, and
    "soft" keeps them staged.

.PARAMETER mode
    The reset mode: "hard", "mixed", or "soft". Defaults to "hard".

.EXAMPLE
    undo-commit
    undo-commit -mode "soft"
#>
function undo-commit {
    [CmdletBinding()]
    param (
        [ValidateSet('hard', 'mixed', 'soft')]
        [string]$mode = 'hard'
    )

    Write-Host 'undo-commit: Undoing the last commit...' -ForegroundColor Yellow
    git reset "--$mode" HEAD~1

    Write-Host 'undo-commit: Pushing changes...' -ForegroundColor Yellow
    git push --force

    Write-Host 'undo-commit: Undo last commit complete.' -ForegroundColor Green
}
