#!/usr/bin/env python3
"""Extract the relative file paths from a .NET stack trace."""

from __future__ import annotations

import argparse
import re
import sys

YELLOW = "\033[93m"
RESET = "\033[0m"

IN_FILE = re.compile(r" in (.+)$")
FRAME_SPLIT = re.compile(r"(?=\bat\s)")
BUILD_PREFIX = re.compile(r"(?i)^[a-z]:/a/1/s/")


def extract_paths(text: str) -> list[str]:
    """Return the relative source paths referenced by the trace."""
    paths: list[str] = []
    for frame in FRAME_SPLIT.split(text):
        if not frame.startswith("at ") or frame.startswith("at Microsoft"):
            continue
        match = IN_FILE.search(frame)
        if not match:
            continue
        path = re.sub(r"[\\]+", "/", match.group(1))
        path = re.sub(r"/{2,}", "/", path)
        path = BUILD_PREFIX.sub("", path)
        paths.append(path.strip())
    return paths


def main() -> int:
    parser = argparse.ArgumentParser(description="Extract file paths from a stack trace.")
    parser.add_argument("path", nargs="?", default="test.txt", help="Stack trace file (default: test.txt).")
    args = parser.parse_args()

    try:
        with open(args.path, encoding="utf-8", errors="ignore") as handle:
            text = handle.read()
    except OSError as error:
        print(f"File not found: {error}", file=sys.stderr)
        return 1

    for path in extract_paths(text):
        print(f"{YELLOW}{path}{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
