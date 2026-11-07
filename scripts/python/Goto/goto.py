#!/usr/bin/env python3
"""Print the path of a frequently used directory.

A child process cannot change its parent shell's working directory, so this
prints the destination instead. Use it as ``cd "$(python goto.py repos)"``.

Fill in the DESTINATIONS map with your own paths.
"""

from __future__ import annotations

import argparse
import sys

# name -> path
DESTINATIONS: dict[str, str] = {
    "locals": "",  # Insert your locals path here
    "repos": "",   # Insert your repos path here
}


def resolve(target: str | None) -> str | None:
    """Return the path for *target*, or None when it is unknown."""
    if not target:
        return None
    return DESTINATIONS.get(target.lower()) or None


def main() -> int:
    parser = argparse.ArgumentParser(description="Print the path of a known directory.")
    parser.add_argument("target", nargs="?", help="Destination to look up.")
    args = parser.parse_args()

    path = resolve(args.target)
    if not path:
        print(f"Option '{args.target}' does not exist.", file=sys.stderr)
        print("\nAvailable options:", file=sys.stderr)
        for name, destination in DESTINATIONS.items():
            print(f"  {name:<8} - {destination}", file=sys.stderr)
        return 1

    print(path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
