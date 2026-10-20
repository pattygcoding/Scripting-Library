function Goto {
    param(
        [string]$target
    )

    # Define destinations in one place
    $destinations = @{
        "locals" = # path here
        "repos"  = # path here
    }

	# Print that the option does not exist if the user gives something invalid, with a guide.
    if ($null -eq $target -or -not $destinations.ContainsKey($target.ToLower())) {
        Write-Host "Option '$target' does not exist." -ForegroundColor Red
        Write-Host "`nAvailable options:" -ForegroundColor Red
        foreach ($key in $destinations.Keys) {
            Write-Host ("  {0,-8} - {1}" -f $key, $destinations[$key])
        }
        return
    }

    # Go to the chosen directory
    $path = $destinations[$target.ToLower()]
    Set-Location $path
    Write-Host "Navigated to $path" -ForegroundColor Green
}
