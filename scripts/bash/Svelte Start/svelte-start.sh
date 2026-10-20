function svelte-start() {
    port=5173

    if command -v wt.exe &> /dev/null; then
        wt.exe powershell.exe -NoExit -Command "npm run dev"
    else
        powershell.exe -NoExit -Command "npm run dev" &
    fi

    if command -v chrome.exe &> /dev/null; then
        chrome.exe "http://localhost:$port/"
    else
        xdg-open "http://localhost:$port/" 2>/dev/null || start "http://localhost:$port/"
    fi
}
