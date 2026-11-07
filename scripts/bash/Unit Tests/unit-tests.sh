# unit-tests - Cleans, builds and tests a .NET unit test project.
unit-tests() {
    local project="$1"

    if [[ -z "$project" ]]; then
        echo "Usage: unit-tests <path-to.csproj>" >&2
        return 1
    fi

    echo -e "\033[33mCleaning...\033[0m"
    dotnet clean "$project"

    echo -e "\033[33mBuilding...\033[0m"
    dotnet build "$project" --no-incremental /p:WarnAsError=false --verbosity minimal

    echo -e "\033[33mTesting...\033[0m"
    dotnet test "$project" --no-build /p:WarnAsError=false --verbosity minimal
}
