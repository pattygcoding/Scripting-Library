#!/usr/bin/env python3
"""Create a new file, defaulting to a .txt extension."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


def create_file(name: str) -> Path:
    """Create *name* (appending .txt when it has no extension) and return its path."""
    path = Path(name)
    if not path.suffix:
        path = path.with_suffix(".txt")
    path.touch(exist_ok=True)
    return path


def main() -> int:
    parser = argparse.ArgumentParser(description="Create a new file, defaulting to .txt.")
    parser.add_argument("name", help="Name of the file to create.")
    args = parser.parse_args()

    path = create_file(args.name)
    print(f"Created {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
