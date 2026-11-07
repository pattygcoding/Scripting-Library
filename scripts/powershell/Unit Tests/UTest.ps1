<#
.SYNOPSIS
    Cleans, builds, and tests a .NET unit test project in a new window.

.DESCRIPTION
    Runs `dotnet clean`, `dotnet build`, and `dotnet test` against the configured
    project in a separate PowerShell window. Set $projectPath to the .csproj you
    want to test. The window stays open so the results can be read.

.EXAMPLE
    UTest
#>
function UTest {
    [CmdletBinding()]
    param ()

    $projectPath = '' # Insert .csproj path here

    $script = @"
`$host.ui.RawUI.WindowTitle = 'Unit Tests'

Write-Host "Cleaning..." -ForegroundColor Yellow
dotnet clean '$projectPath'

Write-Host "Building..." -ForegroundColor Yellow
dotnet build '$projectPath' --no-incremental /p:WarnAsError=false --verbosity minimal

Write-Host "Testing..." -ForegroundColor Yellow
dotnet test '$projectPath' --no-build /p:WarnAsError=false --verbosity minimal

Write-Host "`nPress any key to exit..." -ForegroundColor Cyan
[void][System.Console]::ReadKey(`$true)
"@

    $bytes = [System.Text.Encoding]::Unicode.GetBytes($script)
    $encodedCommand = [Convert]::ToBase64String($bytes)

    Write-Host 'UTest: running project in new window.' -ForegroundColor Yellow
    Start-Process powershell -ArgumentList '-NoExit', '-EncodedCommand', $encodedCommand
}
