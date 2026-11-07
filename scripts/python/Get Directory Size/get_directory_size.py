#!/usr/bin/env python3
"""Print the total byte size of a directory tree."""

from __future__ import annotations

import argparse
import os
import sys


def get_directory_size(directory: str) -> int:
    """Return the total size in bytes of every file under *directory*."""
    total_size = 0
    for dirpath, _, filenames in os.walk(directory):
        for name in filenames:
            try:
                total_size += os.path.getsize(os.path.join(dirpath, name))
            except OSError:
                continue
    return total_size


def main() -> int:
    parser = argparse.ArgumentParser(description="Return the byte size of a directory.")
    parser.add_argument("directory", nargs="?", default=".", help="Directory to measure (default: current).")
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"Error: '{args.directory}' is not a directory.", file=sys.stderr)
        return 1

    total = get_directory_size(args.directory)
    print(f"Total size: {total} bytes ({total / (1024 * 1024):.2f} MB)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
