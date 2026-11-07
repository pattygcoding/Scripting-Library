#!/usr/bin/env python3
"""Build and update an index of .cs files under a directory tree.

Scans a root directory for .cs files and maintains a text index that maps each
file's base name to the directories that contain it. Reports the entries that
were added, removed or changed since the index was last written.
"""

from __future__ import annotations

import argparse
import os
import sys

CYAN = "\033[96m"
GREEN = "\033[92m"
RESET = "\033[0m"


def read_index(index_file: str) -> dict[str, set[str]]:
    """Load an existing index into a name -> directories map."""
    index: dict[str, set[str]] = {}
    if not os.path.exists(index_file):
        return index
    with open(index_file, encoding="utf-8") as handle:
        for line in handle:
            if "|" not in line:
                continue
            name, dirs = line.rstrip("\n").split("|", 1)
            index[name] = {directory for directory in dirs.split(";") if directory}
    return index


def scan(root: str) -> dict[str, set[str]]:
    """Map every .cs base name under *root* to the directories holding it."""
    index: dict[str, set[str]] = {}
    for dirpath, _, filenames in os.walk(root):
        for name in filenames:
            if name.lower().endswith(".cs"):
                index.setdefault(os.path.splitext(name)[0], set()).add(dirpath)
    return index


def update_index(root: str, index_file: str) -> tuple[int, int, int]:
    """Rewrite *index_file* and return the (added, removed, changed) counts."""
    old = read_index(index_file)
    new = scan(root)

    added = sorted(new.keys() - old.keys())
    removed = sorted(old.keys() - new.keys())
    changed = sorted(name for name in new.keys() & old.keys() if new[name] != old[name])

    merged = {name: dirs for name, dirs in old.items() if name not in removed and name not in changed}
    for name in added + changed:
        merged[name] = new[name]

    with open(index_file, "w", encoding="utf-8") as handle:
        for name in sorted(merged):
            handle.write(f"{name}|{';'.join(sorted(merged[name]))}\n")

    return len(added), len(removed), len(changed)


def main() -> int:
    parser = argparse.ArgumentParser(description="Build and update an index of .cs files.")
    parser.add_argument("--root", default=".", help="Root directory to scan (default: current).")
    parser.add_argument("--index-file", required=True, help="Path to the index file to create or update.")
    args = parser.parse_args()

    added, removed, changed = update_index(args.root, args.index_file)
    if added + removed + changed == 0:
        print(f"{GREEN}No changes detected in .cs files under '{args.root}'.{RESET}")
    else:
        print(f"{CYAN}Index updated: +{added} / -{removed} / *{changed}{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
