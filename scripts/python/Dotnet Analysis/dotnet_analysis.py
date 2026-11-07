#!/usr/bin/env python3
"""Summarize DbCommands, actions, action methods and endpoints from a .NET log.

Parses a captured ASP.NET Core console log and prints four grouped sections with
their source line numbers: executed DbCommands (with their database and joined
tables), executed action methods, executed actions and executed endpoints.
"""

from __future__ import annotations

import argparse
import re
import sys

CYAN = "\033[96m"
YELLOW = "\033[93m"
RED = "\033[91m"
RESET = "\033[0m"

DB_NAME = re.compile(r"(?:FROM|UPDATE) \[(\w+)\]")
JOIN_TABLE = re.compile(r"JOIN \[(\w+)\]")


def process_db_block(block: str, line_start: int) -> str:
    """Turn one collected DbCommand block into a one-line summary."""
    match = DB_NAME.search(block)
    db_name = match.group(1) if match else "Unknown DB"
    joins = JOIN_TABLE.findall(block)
    if joins:
        return f"{line_start} [INF] Executed DbCommand from DB [{db_name}] with joins: [{', '.join(joins)}]"
    return f"{line_start} [INF] Executed DbCommand from DB [{db_name}]"


def group_db_lines(lines: list[str]) -> list[str]:
    """Merge consecutive DbCommand summaries whose text matches."""
    grouped: list[str] = []
    previous = ""
    current = ""

    for line in lines:
        number, _, info = line.partition(" ")
        if info == previous and current:
            current += f", {number}"
        else:
            if current:
                grouped.append(f"{current} {previous}")
            current = number
            previous = info

    if current:
        grouped.append(f"{current} {previous}")
    return grouped


def analyze(path: str) -> dict[str, list[str]]:
    """Parse *path* and return the four sections keyed by name."""
    sections: dict[str, list[str]] = {"db": [], "action_method": [], "action": [], "endpoint": []}
    current_block = ""
    current_start = 0

    with open(path, encoding="utf-8", errors="ignore") as handle:
        for number, line in enumerate(handle, start=1):
            if "Executed action method" in line:
                sections["action_method"].append(f"{number} {line.rstrip()}")
            elif "Executed action" in line:
                sections["action"].append(f"{number} {line.rstrip()}")
            elif "Executed endpoint" in line:
                sections["endpoint"].append(f"{number} {line.rstrip()}")
            elif "Executed DbCommand" in line:
                if current_block:
                    sections["db"].append(process_db_block(current_block, current_start))
                current_block = line
                current_start = number
            elif current_block:
                current_block += line

    if current_block:
        sections["db"].append(process_db_block(current_block, current_start))

    return sections


def main() -> int:
    parser = argparse.ArgumentParser(description="Analyze a .NET backend log.")
    parser.add_argument("file", nargs="?", default="TestFile1.txt", help="Log file to analyze.")
    args = parser.parse_args()

    try:
        sections = analyze(args.file)
    except OSError as error:
        print(f"{RED}File not found: {error}{RESET}", file=sys.stderr)
        return 1

    print(f"\n{CYAN}--- Executed DbCommands ---{RESET}")
    for line in group_db_lines(sections["db"]):
        print(f"{YELLOW}{line}{RESET}")
    print(f"\n{CYAN}--- Executed Action Methods ---{RESET}")
    for line in sections["action_method"]:
        print(f"{YELLOW}{line}{RESET}")
    print(f"\n{CYAN}--- Executed Actions ---{RESET}")
    for line in sections["action"]:
        print(f"{YELLOW}{line}{RESET}")
    print(f"\n{CYAN}--- Executed Endpoints ---{RESET}")
    for line in sections["endpoint"]:
        print(f"{YELLOW}{line}{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
