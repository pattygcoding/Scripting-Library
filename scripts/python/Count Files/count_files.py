#!/usr/bin/env python3
"""Count files in the current directory tree, grouped by extension.

Every file under the current directory is counted and the total is printed along
with a breakdown per extension. Files inside node_modules are excluded unless
--includenode is given.
"""

from __future__ import annotations

import argparse
import os
import sys
from collections import defaultdict

CYAN = "\033[96m"
YELLOW = "\033[93m"
RESET = "\033[0m"

NODE_MODULES = "node_modules"


def count_files(include_node: bool = False, directory: str | None = None) -> None:
    """Count files under *directory* and print totals per extension."""
    directory = directory or os.getcwd()

    files_by_extension: defaultdict[str, int] = defaultdict(int)
    total_files = 0

    for root, dirs, files in os.walk(directory):
        if not include_node and NODE_MODULES in dirs:
            dirs.remove(NODE_MODULES)
        for name in files:
            total_files += 1
            files_by_extension[os.path.splitext(name)[1]] += 1

    print(f"{CYAN}Total number of files: {RESET}{YELLOW}{total_files}{RESET}")
    print(f"{CYAN}Files by extension:{RESET}")
    for extension, count in sorted(files_by_extension.items()):
        print(f"{YELLOW}{extension}: {count}{RESET}")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Count files in the current directory, optionally including node_modules."
    )
    parser.add_argument("--includenode", action="store_true", help="Include files in node_modules directories.")
    args = parser.parse_args()

    count_files(args.includenode)
    return 0


if __name__ == "__main__":
    sys.exit(main())
