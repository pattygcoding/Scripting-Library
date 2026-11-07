#!/usr/bin/env python3
"""Count the words in a text file."""

from __future__ import annotations

import argparse
import sys


def count_words(file_path: str) -> int:
    """Return the number of whitespace-separated words in *file_path*."""
    with open(file_path, encoding="utf-8") as handle:
        return len(handle.read().split())


def main() -> int:
    parser = argparse.ArgumentParser(description="Count the words in a text file.")
    parser.add_argument("file", nargs="?", default="textfile.txt", help="The text file to read.")
    args = parser.parse_args()

    try:
        total = count_words(args.file)
    except OSError as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    print(f"Number of words: {total}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
