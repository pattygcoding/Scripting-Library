#!/usr/bin/env python3
"""Find files by name and open each match in Vim."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

YELLOW = "\033[93m"
RED = "\033[91m"
RESET = "\033[0m"


def main() -> int:
    parser = argparse.ArgumentParser(description="Open matching files in Vim.")
    parser.add_argument("file", help="File name to search for.")
    args = parser.parse_args()

    matches = sorted(str(path) for path in Path(".").rglob(args.file))
    if not matches:
        print(f"{RED}No instances of '{args.file}' found.{RESET}", file=sys.stderr)
        return 1

    for path in matches:
        print(f"{YELLOW}Opening {path} in vim{RESET}")
        subprocess.run(["vim", path], check=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
