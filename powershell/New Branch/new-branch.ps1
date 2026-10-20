function new-branch {
	[Parameter(Mandatory=$true, Position=0)]
	[string]$branch
		
	Write-Host("new-branch: Fetching...") -ForegroundColor Yellow
	git fetch
	Write-Host("new-branch: Checking out into new branch $branch...") -ForegroundColor Yellow
	git checkout -b $branch origin/master
	Write-Host("new-branch: Updating new branch $branch with master...") -ForegroundColor Yellow
	git merge origin/master -m "Initial merge"
	Write-Host("new-branch: Pushing your new branch $branch...") -ForegroundColor Yellow
	git push
}
