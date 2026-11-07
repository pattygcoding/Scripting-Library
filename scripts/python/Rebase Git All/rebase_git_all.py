#!/usr/bin/env python3
"""Rebase every local branch onto its upstream.

Self-contained: this repeats the rebase-git steps for each branch rather than
calling the sibling script.
"""

from __future__ import annotations

import argparse
import subprocess
import sys

BLUE = "\033[94m"
GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"

DEFAULT_BRANCH = "master"


def local_branches() -> list[str]:
    """Return the names of all local branches."""
    output = subprocess.run(["git", "branch"], capture_output=True, text=True, check=False).stdout
    return [line.lstrip("* ").strip() for line in output.splitlines() if line.strip()]


def rebase_current(branch: str | None = None) -> int:
    """Rebase the current branch onto origin/<branch> and force-push."""
    target = branch or DEFAULT_BRANCH
    subprocess.run(["git", "fetch"], check=False)
    result = subprocess.run(["git", "rebase", f"origin/{target}"], check=False)
    if result.returncode != 0:
        return 1
    subprocess.run(["git", "push", "--force-with-lease"], check=False)
    return 0


def main() -> int:
    argparse.ArgumentParser(description="Rebase every local branch onto its upstream.").parse_args()

    branches = local_branches()
    if not branches:
        print(f"{RED}No branches found in the repository.{RESET}", file=sys.stderr)
        return 1

    for branch in branches:
        subprocess.run(["git", "checkout", branch], check=False, capture_output=True)
        print(f"{BLUE}Currently on branch: {branch}{RESET}")
        if rebase_current() != 0:
            print(f"{RED}Rebase failed on branch '{branch}'. Resolve manually and continue.{RESET}",
                  file=sys.stderr)
            return 1

    print(f"{GREEN}Finished rebasing all branches onto their upstreams.{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
