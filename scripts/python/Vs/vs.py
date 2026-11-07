#!/usr/bin/env python3
"""Find a file by name and open it in Visual Studio."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys

YELLOW = "\033[93m"
RED = "\033[91m"
RESET = "\033[0m"

IGNORE_DIRS = {"bin", "obj", ".git", "node_modules"}


def find_files(name: str, root: str = ".") -> list[str]:
    """Return files named *name* under *root*, skipping build/VCS folders."""
    matches: list[str] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [directory for directory in dirnames if directory not in IGNORE_DIRS]
        if name in filenames:
            matches.append(os.path.join(dirpath, name))
    return matches


def open_in_visual_studio(paths: list[str]) -> None:
    """Open *paths* in a running Visual Studio instance, else via devenv.exe."""
    try:
        import win32com.client  # type: ignore[import-not-found]

        dte = win32com.client.GetActiveObject("VisualStudio.DTE.17.0")
        for path in paths:
            dte.ItemOperations.OpenFile(path)
    except Exception:
        subprocess.run(["devenv.exe", "/Edit", *paths], check=False)


def main() -> int:
    parser = argparse.ArgumentParser(description="Open a file in Visual Studio.")
    parser.add_argument("file", help="File name or C# class name to search for.")
    args = parser.parse_args()

    search_file = args.file if os.path.splitext(args.file)[1] else f"{args.file}.cs"
    matches = find_files(search_file)
    if not matches:
        print(f"{RED}No instances of '{search_file}' found.{RESET}", file=sys.stderr)
        return 1

    open_in_visual_studio(matches)
    for path in matches:
        print(f"{YELLOW}Opened: {path}{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
