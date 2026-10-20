function ng-start {
    $port = 4200
    Start-Process powershell -ArgumentList '-NoExit', '-Command', 'ng serve'
    Start-Process "chrome.exe" "http://localhost:$port/"
}
