function create-file {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (-not [System.IO.Path]::HasExtension($Name)) {
        $Name = "$Name.txt"
    }

    New-Item -Path $Name -ItemType File -Force | Out-Null
}
