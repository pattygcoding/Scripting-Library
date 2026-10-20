function gensql-count {
	[CmdletBinding()]
	param (
        [Parameter(Mandatory=$true)]
        [string]$t
    )
	
	$script = @"
SELECT COUNT(*) AS total_entries
FROM $t;

"@

	 Write-Host $script -ForegroundColor Magenta
}
