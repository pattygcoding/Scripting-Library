function react-start {
    $port = 3000
    Start-Process powershell -ArgumentList '-NoExit', '-Command', 'npm start'
    Start-Process "chrome.exe" "http://localhost:$port/"
}
