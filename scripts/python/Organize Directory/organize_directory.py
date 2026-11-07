#!/usr/bin/env python3
"""Organize the files in a directory into subfolders by extension."""

from __future__ import annotations

import argparse
import os
import shutil
import sys


def organize_directory(directory: str) -> None:
    """Move each loose file in *directory* into a subfolder named for its extension."""
    for name in os.listdir(directory):
        path = os.path.join(directory, name)
        if not os.path.isfile(path):
            continue

        extension = os.path.splitext(name)[1].lstrip(".").lower() or "no_extension"
        extension_folder = os.path.join(directory, extension)
        os.makedirs(extension_folder, exist_ok=True)
        shutil.move(path, os.path.join(extension_folder, name))


def main() -> int:
    parser = argparse.ArgumentParser(description="Organize a directory by file extension.")
    parser.add_argument("directory", nargs="?", default=".", help="Directory to organize (default: current).")
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"Error: '{args.directory}' is not a directory.", file=sys.stderr)
        return 1

    organize_directory(args.directory)
    return 0


if __name__ == "__main__":
    sys.exit(main())
