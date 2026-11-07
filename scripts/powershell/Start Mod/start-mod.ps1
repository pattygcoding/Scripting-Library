<#
.SYNOPSIS
    Builds and launches a Minecraft mod client via Gradle.

.DESCRIPTION
    Opens a new PowerShell window in the current directory, titles it, runs a
    clean Gradle build, and then starts the client with `./gradlew runClient`.

.EXAMPLE
    Start-Mod
#>
function Start-Mod {
    [CmdletBinding()]
    param ()

    Start-Process powershell -ArgumentList '-NoExit', '-Command', "cd `"$PWD`"; `$Host.UI.RawUI.WindowTitle = 'SupremeMC (1.21.10)'; ./gradlew clean build; ./gradlew runClient" -WorkingDirectory $PWD
}
