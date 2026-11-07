#!/usr/bin/env python3
"""Print text with optional ANSI color.

A small wrapper that adds color to ``print``: ``python print.py "Hello" --color red``.
"""

from __future__ import annotations

import argparse
import sys

COLORS = {
    "black": "\033[30m",
    "red": "\033[91m",
    "green": "\033[92m",
    "yellow": "\033[93m",
    "blue": "\033[94m",
    "magenta": "\033[95m",
    "cyan": "\033[96m",
    "white": "\033[97m",
}
RESET = "\033[0m"


def println(message: str, color: str | None = None, newline: bool = True) -> None:
    """Print *message*, optionally wrapped in an ANSI *color*."""
    prefix = COLORS.get(color, "") if color else ""
    suffix = RESET if prefix else ""
    print(f"{prefix}{message}{suffix}", end="\n" if newline else "")


def main() -> int:
    parser = argparse.ArgumentParser(description="Print text with optional color.")
    parser.add_argument("message", nargs="+", help="Text to print.")
    parser.add_argument("--color", choices=sorted(COLORS), help="Foreground color.")
    parser.add_argument("--no-newline", action="store_true", help="Do not print a trailing newline.")
    args = parser.parse_args()

    println(" ".join(args.message), args.color, newline=not args.no_newline)
    return 0


if __name__ == "__main__":
    sys.exit(main())
