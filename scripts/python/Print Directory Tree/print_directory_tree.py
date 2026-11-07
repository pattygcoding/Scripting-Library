#!/usr/bin/env python3
"""Print a directory tree on the terminal."""

from __future__ import annotations

import argparse
import os
import sys


def print_directory_tree(start_path: str) -> None:
    """Print the tree rooted at *start_path*."""
    start_path = os.path.abspath(start_path)
    for root, _, files in os.walk(start_path):
        level = root.replace(start_path, "").count(os.sep)
        indent = " " * 4 * level
        print(f"{indent}{os.path.basename(root)}/")
        sub_indent = " " * 4 * (level + 1)
        for name in files:
            print(f"{sub_indent}{name}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Print the current directory tree.")
    parser.add_argument("directory", nargs="?", default=".", help="Directory to print (default: current).")
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"Error: '{args.directory}' is not a directory.", file=sys.stderr)
        return 1

    print_directory_tree(args.directory)
    return 0


if __name__ == "__main__":
    sys.exit(main())
