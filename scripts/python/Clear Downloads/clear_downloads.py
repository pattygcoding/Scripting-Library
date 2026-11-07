#!/usr/bin/env python3
"""Delete everything inside the current user's Downloads folder."""

from __future__ import annotations

import argparse
import os
import shutil
import sys

YELLOW = "\033[93m"
GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"


def clear_downloads(directory: str) -> None:
    """Remove every file and folder inside *directory*."""
    for name in os.listdir(directory):
        path = os.path.join(directory, name)
        if os.path.isdir(path) and not os.path.islink(path):
            shutil.rmtree(path, ignore_errors=True)
        else:
            os.remove(path)


def main() -> int:
    default = os.path.join(os.path.expanduser("~"), "Downloads")
    parser = argparse.ArgumentParser(description="Clear the Downloads folder.")
    parser.add_argument("directory", nargs="?", default=default, help="Folder to clear (default: ~/Downloads).")
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"{RED}Downloads folder not found: {args.directory}{RESET}", file=sys.stderr)
        return 1

    print(f"{YELLOW}Deleting all contents in {args.directory}...{RESET}")
    clear_downloads(args.directory)
    print(f"{GREEN}Downloads folder cleared permanently.{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
