#!/usr/bin/env python3
"""Fetch and merge the latest changes into the current Git branch.

Fetches the remote, merges ``origin/<branch>`` (``origin/master`` by default)
into the current branch and pushes the result.
"""

from __future__ import annotations

import argparse
import subprocess
import sys

YELLOW = "\033[93m"
GREEN = "\033[92m"
RESET = "\033[0m"

DEFAULT_BRANCH = "master"


def run_command(command: list[str]) -> str:
    """Run a git *command*, exiting on failure. Returns its standard output."""
    result = subprocess.run(command, text=True, capture_output=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr.strip()}", file=sys.stderr)
        raise SystemExit(result.returncode)
    return result.stdout


def update_git(branch: str | None = None) -> None:
    """Merge a remote branch into the current branch and push."""
    target = branch or DEFAULT_BRANCH
    merge_branch = f"origin/{target}"

    print(f"{YELLOW}update-git: Fetching...{RESET}")
    run_command(["git", "fetch"])

    message = (
        f"Auto-merge update: Merged {target} to branch using update-git "
        f"Python script (git fetch; git merge {merge_branch}; git push;)"
    )
    print(f"{YELLOW}update-git: Merging {merge_branch} into the current branch...{RESET}")
    run_command(["git", "merge", merge_branch, "-m", message])

    print(f"{YELLOW}update-git: Pushing changes...{RESET}")
    run_command(["git", "push"])

    print(f"{GREEN}update-git: Auto-merge complete. Your branch is now up to date with {target}.{RESET}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Update the current Git branch with another branch.")
    parser.add_argument("-b", "--branch", help="The branch to merge into the current branch (default: master).")
    args = parser.parse_args()

    update_git(args.branch)
    return 0


if __name__ == "__main__":
    sys.exit(main())
