#!/usr/bin/env python3
"""Compare two text files line by line and highlight the differences.

Lines that appear only in the first file are shown in red and lines that appear
only in the second file are shown in green. Pass --notime to ignore log
timestamps and "(123ms)" durations during the comparison.
"""

from __future__ import annotations

import argparse
import re
import sys

RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
RESET = "\033[0m"

TIMESTAMP_PATTERN = re.compile(r"\[\d{2}:\d{2}:\d{2}\s\w{3}\]|\(\d+ms\)")


def strip_timestamps(lines: list[str]) -> list[str]:
    """Remove log timestamps and duration markers from each line."""
    return [TIMESTAMP_PATTERN.sub("", line) for line in lines]


def compare_diff(file1: str, file2: str, no_time: bool = False) -> int:
    """Print the differences between two files and return an exit code."""
    try:
        with open(file1, encoding="utf-8") as handle1:
            content1 = handle1.readlines()
        with open(file2, encoding="utf-8") as handle2:
            content2 = handle2.readlines()
    except OSError as error:
        print(f"{RED}Error: {error}{RESET}", file=sys.stderr)
        return 1

    if no_time:
        print(
            f"{YELLOW}Please note that since you included the --notime flag, "
            f"timestamps will not be compared or displayed.{RESET}"
        )
        content1 = strip_timestamps(content1)
        content2 = strip_timestamps(content2)

    print(f"\n{RED}RED = {file1}{RESET}")
    print(f"{GREEN}GREEN = {file2}{RESET}\n")

    differences = 0
    for index in range(max(len(content1), len(content2))):
        line1 = content1[index] if index < len(content1) else ""
        line2 = content2[index] if index < len(content2) else ""
        if line1 == line2:
            continue
        if line1:
            print(f"{RED}- {line1.strip()}{RESET}")
            differences += 1
        if line2:
            print(f"{GREEN}+ {line2.strip()}{RESET}")
            differences += 1

    return 0 if differences == 0 else 1


def main() -> int:
    parser = argparse.ArgumentParser(description="Compare two files line by line.")
    parser.add_argument("file1", nargs="?", default="TestFile1.txt", help="The first file to compare.")
    parser.add_argument("file2", nargs="?", default="TestFile2.txt", help="The second file to compare.")
    parser.add_argument("--notime", action="store_true", help="Remove timestamps before comparing.")
    args = parser.parse_args()

    return compare_diff(args.file1, args.file2, args.notime)


if __name__ == "__main__":
    sys.exit(main())
