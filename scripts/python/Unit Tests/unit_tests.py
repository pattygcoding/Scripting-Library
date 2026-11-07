#!/usr/bin/env python3
"""Clean, build and test a .NET unit test project."""

from __future__ import annotations

import argparse
import subprocess
import sys

YELLOW = "\033[93m"
RESET = "\033[0m"

# Insert the path to your .csproj here.
PROJECT_PATH = ""


def main() -> int:
    parser = argparse.ArgumentParser(description="Clean, build and test a .NET project.")
    parser.add_argument("--project", default=PROJECT_PATH, help="Path to the .csproj to test.")
    args = parser.parse_args()

    if not args.project:
        print("Error: set --project or PROJECT_PATH to your .csproj.", file=sys.stderr)
        return 1

    print(f"{YELLOW}Cleaning...{RESET}")
    subprocess.run(["dotnet", "clean", args.project], check=False)

    print(f"{YELLOW}Building...{RESET}")
    subprocess.run(
        ["dotnet", "build", args.project, "--no-incremental", "/p:WarnAsError=false", "--verbosity", "minimal"],
        check=False,
    )

    print(f"{YELLOW}Testing...{RESET}")
    result = subprocess.run(
        ["dotnet", "test", args.project, "--no-build", "/p:WarnAsError=false", "--verbosity", "minimal"],
        check=False,
    )
    return result.returncode


if __name__ == "__main__":
    sys.exit(main())
