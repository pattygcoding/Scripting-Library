<#
.SYNOPSIS
    Starts or reloads a local Nginx server.

.DESCRIPTION
    If Nginx is already running, reloads its configuration. Otherwise, starts a
    new Nginx instance using the configured executable and config file. Set
    $nginxBase to the root of your Nginx installation.

.EXAMPLE
    nginx
#>
function nginx {
    [CmdletBinding()]
    param ()

    $nginxBase = '' # Insert the path to your nginx installation here
    $nginxExe = "$nginxBase\nginx.exe"
    $nginxConf = "$nginxBase\conf\nginx.conf"

    $nginxProcess = Get-Process -Name nginx -ErrorAction SilentlyContinue

    if ($nginxProcess) {
        Start-Process powershell -WorkingDirectory $nginxBase -ArgumentList '-NoExit', '-Command', "& `'$nginxExe`' -s reload"
    }
    else {
        Start-Process powershell -WorkingDirectory $nginxBase -ArgumentList '-NoExit', '-Command', "& `'$nginxExe`' -c `'$nginxConf`'"
    }
}
