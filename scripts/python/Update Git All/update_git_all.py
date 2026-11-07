#!/usr/bin/env python3
"""Update every local branch with the latest changes.

Self-contained: this repeats the update-git steps for each branch rather than
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


def update_branch(branch: str | None = None) -> None:
    """Merge origin/<branch> into the current branch and push."""
    target = branch or DEFAULT_BRANCH
    merge_branch = f"origin/{target}"
    subprocess.run(["git", "fetch"], check=False)
    message = (
        f"Auto-merge update: Merged {target} to branch using update-git-all "
        f"Python script (git fetch; git merge {merge_branch}; git push;)"
    )
    subprocess.run(["git", "merge", merge_branch, "-m", message], check=False)
    subprocess.run(["git", "push"], check=False)


def main() -> int:
    argparse.ArgumentParser(description="Update every local branch.").parse_args()

    branches = local_branches()
    if not branches:
        print(f"{RED}No branches found in the repository.{RESET}", file=sys.stderr)
        return 1

    for branch in branches:
        subprocess.run(["git", "checkout", branch], check=False, capture_output=True)
        print(f"{BLUE}Currently on branch: {branch}{RESET}")
        update_branch()

    print(f"{GREEN}Finished processing all branches.{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
