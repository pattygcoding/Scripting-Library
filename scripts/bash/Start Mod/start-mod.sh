# start-mod - Builds and launches a Minecraft mod client via Gradle.
start-mod() {
    local skip_build=false
    local arg
    for arg in "$@"; do
        [[ "$arg" == "--skip-build" ]] && skip_build=true
    done

    local gradlew="./gradlew"
    [[ -f "./gradlew.bat" ]] && gradlew="./gradlew.bat"

    if ! $skip_build; then
        "$gradlew" clean build
    fi
    "$gradlew" runClient
}
