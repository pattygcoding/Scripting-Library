<#
.SYNOPSIS
    Prints the machine's IPv4 addresses.

.DESCRIPTION
    Lists the IPv4 addresses assigned to the machine, excluding well-known
    (loopback / reserved) origins.

.EXAMPLE
    ip
#>
function ip {
    [CmdletBinding()]
    param ()

    Get-NetIPAddress |
        Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -ne 'WellKnown' } |
        Select-Object -ExpandProperty IPAddress
}
