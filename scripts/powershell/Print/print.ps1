function print {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments = $true, Position = 0)]
        $Object,

        [ConsoleColor] $ForegroundColor,
        [ConsoleColor] $BackgroundColor,
        [switch] $NoNewline
    )

    $params = @{}

    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        $params['ForegroundColor'] = $ForegroundColor
    }

    if ($PSBoundParameters.ContainsKey('BackgroundColor')) {
        $params['BackgroundColor'] = $BackgroundColor
    }

    if ($NoNewline) {
        $params['NoNewline'] = $true
    }

    Write-Host @params @Object
}
