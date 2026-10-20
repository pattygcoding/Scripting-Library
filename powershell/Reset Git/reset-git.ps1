function Reset-Git {
	Write-Host("reset-git: Fetching...") -ForegroundColor Yellow
    git fetch
	
	Write-Host("reset-git: Resetting branch to original state...") -ForegroundColor Yellow
    git reset --hard origin/main
	
	Write-Host ("reset-git: Pushing changes...") -ForegroundColor Yellow
    git push --force
	
	Write-Host("reset-git: Reset git complete.") -ForegroundColor Green
}
