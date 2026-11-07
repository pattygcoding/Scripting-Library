#!/usr/bin/env python3
"""Undo the last commit and force-push the rewrite."""

from __future__ import annotations

import argparse
import subprocess
import sys

YELLOW = "\033[93m"
GREEN = "\033[92m"
RESET = "\033[0m"


def main() -> int:
    parser = argparse.ArgumentParser(description="Undo the last commit.")
    parser.add_argument("-m", "--mode", choices=("hard", "mixed", "soft"), default="hard",
                        help="Reset mode (default: hard).")
    args = parser.parse_args()

    print(f"{YELLOW}undo-commit: Undoing the last commit...{RESET}")
    subprocess.run(["git", "reset", f"--{args.mode}", "HEAD~1"], check=False)
    print(f"{YELLOW}undo-commit: Pushing changes...{RESET}")
    subprocess.run(["git", "push", "--force"], check=False)
    print(f"{GREEN}undo-commit: Undo last commit complete.{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
