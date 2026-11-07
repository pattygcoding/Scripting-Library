<#
.SYNOPSIS
    Deletes local branches that have no remote (origin) counterpart.

.DESCRIPTION
    Lists local branches with their tracking information and force-deletes every
    branch that is not tracking an origin branch. The branch you are currently on
    is never deleted.

    WARNING: branches that were never pushed will be lost.

.EXAMPLE
    clear-git
#>
function clear-git {
    [CmdletBinding()]
    param ()

    git branch -vv |
        Where-Object { $_ -notmatch '\[origin/' } |
        ForEach-Object { ($_ -split '\s+')[1] } |
        ForEach-Object { git branch -D $_ }
}
