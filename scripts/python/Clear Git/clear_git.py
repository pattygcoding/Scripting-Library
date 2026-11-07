#!/usr/bin/env python3
"""Delete local branches that have no remote (origin) counterpart.

WARNING: branches that were never pushed will be lost.
"""

from __future__ import annotations

import argparse
import subprocess
import sys


def run_git(*args: str) -> str:
    """Run a git command and return its standard output."""
    return subprocess.run(["git", *args], capture_output=True, text=True, check=False).stdout


def clear_git() -> int:
    """Force-delete every local branch that is not tracking an origin branch."""
    deleted = 0
    for line in run_git("branch", "-vv").splitlines():
        if not line.strip() or "[origin/" in line:
            continue
        parts = line.split()
        branch = parts[1] if parts[0] == "*" else parts[0]
        subprocess.run(["git", "branch", "-D", branch], check=False)
        deleted += 1
    return deleted


def main() -> int:
    argparse.ArgumentParser(description="Delete local branches without an origin counterpart.").parse_args()
    print(f"Deleted {clear_git()} branch(es).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
