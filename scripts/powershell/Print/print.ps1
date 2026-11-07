<#
.SYNOPSIS
    Write-Host with color, background, and no-newline support.

.DESCRIPTION
    A thin wrapper around Write-Host that forwards any objects plus optional
    foreground/background colors and a no-newline switch, so colored output can
    be written concisely.

.PARAMETER Object
    One or more objects to print. Accepted from the remaining arguments.

.PARAMETER ForegroundColor
    The text color.

.PARAMETER BackgroundColor
    The text background color.

.PARAMETER NoNewline
    Switch. Suppress the trailing newline.

.EXAMPLE
    print "Hello World" -ForegroundColor Red
    print "Text" -BackgroundColor Blue -NoNewline
#>
function print {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments = $true, Position = 0)]
        $Object,

        [ConsoleColor]$ForegroundColor,
        [ConsoleColor]$BackgroundColor,
        [switch]$NoNewline
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
