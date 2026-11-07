#!/usr/bin/env python3
"""Squash the current branch into a single commit.

Fetches, soft-resets to origin/main so all changes are staged, commits them as
one and force-pushes.
"""

from __future__ import annotations

import argparse
import subprocess
import sys

YELLOW = "\033[93m"
GREEN = "\033[92m"
RESET = "\033[0m"


def run(command: list[str]) -> None:
    """Run *command*, exiting with its status code on failure."""
    result = subprocess.run(command, check=False)
    if result.returncode != 0:
        raise SystemExit(result.returncode)


def compress_git(message: str) -> None:
    """Squash the current branch into one commit with *message*."""
    print(f"{YELLOW}compress-git: Fetching...{RESET}")
    run(["git", "fetch"])
    print(f"{YELLOW}compress-git: Staging changes for compression...{RESET}")
    run(["git", "reset", "--soft", "origin/main"])
    print(f"{YELLOW}compress-git: Committing changes...{RESET}")
    run(["git", "commit", "-m", message])
    print(f"{YELLOW}compress-git: Pushing changes...{RESET}")
    run(["git", "push", "--force"])
    print(f"{GREEN}compress-git: Compress git complete.{RESET}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Compress the current branch into one commit.")
    parser.add_argument("message", help="Commit message for the squashed commit.")
    args = parser.parse_args()

    compress_git(args.message)
    return 0


if __name__ == "__main__":
    sys.exit(main())
