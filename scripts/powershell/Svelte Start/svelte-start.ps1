function svelte-start {
    $port = 5173
    Start-Process powershell -ArgumentList '-NoExit', '-Command', 'npm run dev'
    Start-Process "chrome.exe" "http://localhost:$port/"
}
