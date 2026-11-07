#!/usr/bin/env python3
"""Rebase the current branch onto origin/master or a given branch."""

from __future__ import annotations

import argparse
import subprocess
import sys

YELLOW = "\033[93m"
GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"

DEFAULT_BRANCH = "master"


def rebase(branch: str | None = None) -> int:
    """Rebase the current branch onto origin/<branch> and force-push."""
    target = branch or DEFAULT_BRANCH
    rebase_branch = f"origin/{target}"

    print(f"{YELLOW}rebase-git: Fetching latest changes...{RESET}")
    subprocess.run(["git", "fetch"], check=False)

    print(f"{YELLOW}rebase-git: Rebasing onto {rebase_branch}...{RESET}")
    result = subprocess.run(["git", "rebase", rebase_branch], check=False)
    if result.returncode != 0:
        print(
            f"{RED}rebase-git: Rebase failed. Resolve conflicts and run "
            f"'git rebase --continue' manually.{RESET}",
            file=sys.stderr,
        )
        return 1

    print(f"{YELLOW}rebase-git: Rebase successful. Pushing rebased changes...{RESET}")
    subprocess.run(["git", "push", "--force-with-lease"], check=False)

    print(f"{GREEN}rebase-git: Rebase complete. Your branch is now up to date with "
          f"{target} (no merge commit).{RESET}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Rebase the current branch onto a remote branch.")
    parser.add_argument("-b", "--branch", help="Branch to rebase onto (default: master).")
    args = parser.parse_args()

    return rebase(args.branch)


if __name__ == "__main__":
    sys.exit(main())
