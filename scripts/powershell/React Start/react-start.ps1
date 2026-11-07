<#
.SYNOPSIS
    Starts a React development server and opens it in Chrome.

.DESCRIPTION
    Launches `npm start` in a new PowerShell window and then opens
    http://localhost:3000/ in Chrome.

.EXAMPLE
    react-start
#>
function react-start {
    [CmdletBinding()]
    param ()

    $port = 3000

    Start-Process powershell -ArgumentList '-NoExit', '-Command', 'npm start'
    Start-Process 'chrome.exe' "http://localhost:$port/"
}
