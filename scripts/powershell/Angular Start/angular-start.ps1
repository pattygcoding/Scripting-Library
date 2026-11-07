<#
.SYNOPSIS
    Starts an Angular development server and opens it in Chrome.

.DESCRIPTION
    Launches `ng serve` in a new PowerShell window and then opens
    http://localhost:4200/ in Chrome.

.EXAMPLE
    ng-start
#>
function ng-start {
    [CmdletBinding()]
    param ()

    $port = 4200

    Start-Process powershell -ArgumentList '-NoExit', '-Command', 'ng serve'
    Start-Process 'chrome.exe' "http://localhost:$port/"
}
