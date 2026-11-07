<#
.SYNOPSIS
    Creates a new file, defaulting to a .txt extension.

.DESCRIPTION
    Creates a file with the given name. If the name has no extension, ".txt" is
    appended.

.PARAMETER Name
    The name of the file to create. Required.

.EXAMPLE
    create-file "myfile"
    create-file "document.txt"
#>
function create-file {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (-not [System.IO.Path]::HasExtension($Name)) {
        $Name = "$Name.txt"
    }

    New-Item -Path $Name -ItemType File -Force | Out-Null
}
