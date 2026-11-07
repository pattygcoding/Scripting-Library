<#
.SYNOPSIS
    Starts a Svelte development server and opens it in Chrome.

.DESCRIPTION
    Launches `npm run dev` in a new PowerShell window and then opens
    http://localhost:5173/ in Chrome.

.EXAMPLE
    svelte-start
#>
function svelte-start {
    [CmdletBinding()]
    param ()

    $port = 5173

    Start-Process powershell -ArgumentList '-NoExit', '-Command', 'npm run dev'
    Start-Process 'chrome.exe' "http://localhost:$port/"
}
