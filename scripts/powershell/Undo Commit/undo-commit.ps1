function undo-commit {
    param(
        [string]$mode = "hard"
    )

    if ($mode -notin @("hard", "mixed", "soft")) {
        Write-Host ("Invalid mode specified. Use 'hard', 'mixed', or 'soft'.") -ForegroundColor Red
        exit 1
    }

    Write-Host("undo-commit: Undoing the last commit...") -ForegroundColor Yellow
    git reset --$mode HEAD~1
  	Write-Host("undo-commit: Pushing changes...") -ForegroundColor Yellow
    git push --force
    Write-Host("undo-commit: Undo last commit complete.") -ForegroundColor Green
}
