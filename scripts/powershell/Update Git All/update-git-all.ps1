function Update-Git-All {
    $branches = git branch | ForEach-Object {
        $_.TrimStart('*').Trim()
    }

    if ($branches.Count -eq 0) {
        Write-Host "No branches found in the repository." -ForegroundColor Red
        return
    }

    foreach ($branch in $branches) {
        git checkout $branch | Out-Null
        Write-Host "Currently on branch: $branch" -ForegroundColor Blue
        update-git
    }

    Write-Host "Finished processing all branches." -ForegroundColor Green
}
