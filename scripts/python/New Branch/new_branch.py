#!/usr/bin/env python3
"""Create a new Git branch from origin/master and push it."""

from __future__ import annotations

import argparse
import subprocess
import sys

YELLOW = "\033[93m"
RESET = "\033[0m"


def run(command: list[str]) -> None:
    """Run *command*, exiting with its status code on failure."""
    result = subprocess.run(command, check=False)
    if result.returncode != 0:
        raise SystemExit(result.returncode)


def main() -> int:
    parser = argparse.ArgumentParser(description="Create a new branch from origin/master and push it.")
    parser.add_argument("branch", help="Name of the new branch.")
    args = parser.parse_args()

    print(f"{YELLOW}new-branch: Fetching...{RESET}")
    run(["git", "fetch"])
    print(f"{YELLOW}new-branch: Checking out into new branch {args.branch}...{RESET}")
    run(["git", "checkout", "-b", args.branch, "origin/master"])
    print(f"{YELLOW}new-branch: Updating new branch {args.branch} with master...{RESET}")
    run(["git", "merge", "origin/master", "-m", "Initial merge"])
    print(f"{YELLOW}new-branch: Pushing your new branch {args.branch}...{RESET}")
    run(["git", "push"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
