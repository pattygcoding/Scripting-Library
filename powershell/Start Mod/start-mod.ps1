function Start-Mod {
    Start-Process powershell -ArgumentList '-NoExit', '-Command', "cd `"$PWD`"; `$Host.UI.RawUI.WindowTitle = 'SupremeMC (1.21.10)'; ./gradlew clean build; ./gradlew runClient" -WorkingDirectory $PWD
}
