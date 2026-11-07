<#
.SYNOPSIS
    Jumps to a frequently used directory.

.DESCRIPTION
    Changes the current location to one of the predefined destinations. Fill in
    the $destinations hashtable with your own paths. An unknown or missing target
    prints the list of available options.

.PARAMETER target
    The key of the destination to navigate to.

.EXAMPLE
    Goto repos
#>
function Goto {
    [CmdletBinding()]
    param (
        [string]$target
    )

    # Define your destinations here: name = path.
    $destinations = @{
        'locals' = '' # Insert your locals path here
        'repos'  = '' # Insert your repos path here
    }

    if ($null -eq $target -or -not $destinations.ContainsKey($target.ToLower())) {
        Write-Host "Option '$target' does not exist." -ForegroundColor Red
        Write-Host "`nAvailable options:" -ForegroundColor Red
        foreach ($key in $destinations.Keys) {
            Write-Host ('  {0,-8} - {1}' -f $key, $destinations[$key])
        }
        return
    }

    $path = $destinations[$target.ToLower()]
    Set-Location $path
    Write-Host "Navigated to $path" -ForegroundColor Green
}
