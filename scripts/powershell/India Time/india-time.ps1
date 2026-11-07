<#
.SYNOPSIS
    Converts a time to India Standard Time (IST).

.DESCRIPTION
    With no input, prints the current time in India. With -InputTime, converts
    the supplied local time to IST. Accepts times such as "8:26 AM".

.PARAMETER InputTime
    The local time to convert, in 'h:mm AM/PM' format. Optional; the current
    time is shown when omitted.

.EXAMPLE
    india-time
    india-time -InputTime "8:26 AM"
#>
function india-time {
    [CmdletBinding()]
    param (
        [string]$InputTime
    )

    $istZone = [System.TimeZoneInfo]::FindSystemTimeZoneById('India Standard Time')

    function Convert-ToIndiaTime {
        param ($dateTime)
        return [System.TimeZoneInfo]::ConvertTime($dateTime, [System.TimeZoneInfo]::Local, $istZone)
    }

    if (-not $InputTime) {
        $now = Get-Date
        $indiaTime = Convert-ToIndiaTime $now
        Write-Output "Current time in India: $($indiaTime.ToString('hh:mm tt'))"
    }
    elseif ($InputTime -match '^(0?[1-9]|1[0-2]):[0-5][0-9]\s?[AaPp][Mm]$') {
        try {
            $localDateTime = [datetime]::Parse($InputTime)
            $indiaTime = Convert-ToIndiaTime $localDateTime
            Write-Output "Inputted time in India: $($indiaTime.ToString('hh:mm tt'))"
        }
        catch {
            Write-Host 'Failed to parse time.' -ForegroundColor Red
        }
    }
    else {
        Write-Host "Invalid time format. Use format like '8:26 AM'." -ForegroundColor Red
    }
}
