<#
.SYNOPSIS
    Generates a random password.

.DESCRIPTION
    Prints a random password containing upper- and lower-case letters, digits,
    and common symbols.

.PARAMETER l
    The length of the password. Defaults to 12.

.EXAMPLE
    random-password
    random-password -l 24
#>
function random-password {
    [CmdletBinding()]
    param (
        [int]$l = 12
    )

    $characters = @(
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+'
    )

    $password = -join (1..$l | ForEach-Object { $characters | Get-Random })

    Write-Host 'Generated password: ' -ForegroundColor Cyan -NoNewline
    Write-Host $password -ForegroundColor Yellow
}
