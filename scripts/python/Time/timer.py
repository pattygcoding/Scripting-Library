#!/usr/bin/env python3
"""Measure how long a command takes to run."""

from __future__ import annotations

import argparse
import subprocess
import sys
import time

MAGENTA = "\033[95m"
RESET = "\033[0m"


def main() -> int:
    parser = argparse.ArgumentParser(description="Time an operation.")
    parser.add_argument("command", nargs=argparse.REMAINDER, help="Command to run and time.")
    args = parser.parse_args()

    command = args.command
    if not command:
        parser.error("provide a command to time")

    start = time.perf_counter()
    result = subprocess.run(" ".join(command), shell=True, check=False)
    elapsed = time.perf_counter() - start

    print(f"\n{MAGENTA}The task took {elapsed:.6f} seconds to complete.{RESET}\n")
    return result.returncode


if __name__ == "__main__":
    sys.exit(main())
