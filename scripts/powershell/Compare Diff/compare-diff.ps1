function compare-diff {
    param (
        [string]$f1 = "TestFile1.txt",
        [string]$f2 = "TestFile2.txt",
        [switch]$notime
    )
	
	Write-Host "`nRED = $f1" -ForegroundColor Red
	Write-Host "GREEN = $f2`n" -ForegroundColor Green

    # Define a function to remove timestamps and specified patterns
    function Remove-Timestamps {
        param (
            [string[]]$lines
        )
        $pattern = "\[\d{2}:\d{2}:\d{2}\s\w{3}\]|\(\d+ms\)"
        return $lines -replace $pattern, ""
    }

    # Get the contents of the files
    $content1 = Get-Content -Path $f1
    $content2 = Get-Content -Path $f2

    # Remove timestamps and specified patterns if the switch is provided
    if ($notime) {
		Write-Host "Please note that since you included the -notime flag, timestamps will not be compared or displayed." -ForegroundColor Yellow
        $content1 = Remove-Timestamps -lines $content1
        $content2 = Remove-Timestamps -lines $content2
    }

    # Compare the processed contents
    $differences = Compare-Object -ReferenceObject $content1 -DifferenceObject $content2

    # Display the differences with custom formatting
    foreach ($difference in $differences) {
        if ($difference.SideIndicator -eq "<=") {
            Write-Host "- $($difference.InputObject)" -ForegroundColor Red
        } elseif ($difference.SideIndicator -eq "=>") {
            Write-Host "+ $($difference.InputObject)" -ForegroundColor Green
        }
    }
}
