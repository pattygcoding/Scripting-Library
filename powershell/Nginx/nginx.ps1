function nginx {
    $nginxBase = # Insert directory path here to your nginx setup
    $nginxExe = "$nginxBase\nginx.exe"
    $nginxConf = "$nginxBase\conf\nginx.conf"

    $nginxProcess = Get-Process -Name nginx -ErrorAction SilentlyContinue

    if ($nginxProcess) {
        Start-Process powershell -WorkingDirectory $nginxBase -ArgumentList '-NoExit', '-Command', "& `'$nginxExe`' -s reload"
    } else {
        Start-Process powershell -WorkingDirectory $nginxBase -ArgumentList '-NoExit', '-Command', "& `'$nginxExe`' -c `'$nginxConf`'"
    }
}
