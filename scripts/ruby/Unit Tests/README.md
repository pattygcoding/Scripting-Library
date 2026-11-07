## Unit Tests
This script cleans, builds, and tests a .NET unit test project with `dotnet clean`, `dotnet build`, and `dotnet test`.

### Dependencies
- **.NET SDK**: `dotnet` must be in your PATH

### Arguments
- `--project`: Path to the `.csproj` to test. Defaults to the `PROJECT_PATH` constant.

### Example Usage
```
ruby unit-tests.rb --project MyProject.Tests.csproj
```
