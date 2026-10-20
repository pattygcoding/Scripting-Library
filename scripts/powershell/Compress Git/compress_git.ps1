function Compress-Git {
	param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$message
    )
	
	Write-Host("compress-git: Fetching...") -ForegroundColor Yellow
    git fetch
	
	Write-Host("compress-git: Staging changes for compression...") -ForegroundColor Yellow
    git reset --soft origin/main
	
	Write-Host ("compress-git: Committing changes...") -ForegroundColor Yellow
	git commit -m $message
	
	Write-Host ("compress-git: Pushing changes...") -ForegroundColor Yellow
    git push --force
	
	Write-Host("compress-git: Compress git complete.") -ForegroundColor Green
}
