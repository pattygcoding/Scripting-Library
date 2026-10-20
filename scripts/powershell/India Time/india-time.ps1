function india-time {
    param (
        [string]$InputTime
    )

    $istZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("India Standard Time")

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
            Write-Host "Failed to parse time." -ForegroundColor Red
        }
    }
    else {
        Write-Host "Invalid time format. Use format like '8:26 AM'." -ForegroundColor Red
    }
}
