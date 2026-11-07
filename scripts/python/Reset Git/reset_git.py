#!/usr/bin/env python3
"""Hard-reset the current branch to origin/main and force-push."""

from __future__ import annotations

import argparse
import subprocess
import sys

YELLOW = "\033[93m"
GREEN = "\033[92m"
RESET = "\033[0m"


def main() -> int:
    argparse.ArgumentParser(description="Hard-reset the current branch to origin/main.").parse_args()

    print(f"{YELLOW}reset-git: Fetching...{RESET}")
    subprocess.run(["git", "fetch"], check=False)
    print(f"{YELLOW}reset-git: Resetting branch to original state...{RESET}")
    subprocess.run(["git", "reset", "--hard", "origin/main"], check=False)
    print(f"{YELLOW}reset-git: Pushing changes...{RESET}")
    subprocess.run(["git", "push", "--force"], check=False)
    print(f"{GREEN}reset-git: Reset git complete.{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
