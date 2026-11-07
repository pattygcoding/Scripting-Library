#!/usr/bin/env python3
"""Search files of a given extension for one or more terms.

Recursively scans files matching ``extension`` in the current directory and
prints every matching line with its line number. Supports a result cap
(``--uncapped``), cross-term / AND matching (``--cross``), full-path output
(``--dir``) and method-call filtering (``--calls``).
"""

from __future__ import annotations

import argparse
import os
import re
import sys

MAX_RESULTS = 3000


def search_match(
    extension: str,
    terms: list[str],
    uncapped: bool = False,
    cross: bool = False,
    show_dir: bool = False,
    calls: bool = False,
) -> None:
    """Print matches for *terms* inside files ending with *extension*."""
    if not extension.startswith("."):
        extension = f".{extension}"

    results_count = 0
    cap_reached = False
    current_dir = os.getcwd()

    def print_header(file_path: str) -> None:
        print(file_path if show_dir else os.path.basename(file_path))

    for root, _, files in os.walk(current_dir):
        if cap_reached:
            break

        for file_name in files:
            if not file_name.endswith(extension):
                continue

            file_path = os.path.join(root, file_name)
            printed_name = False
            skip_using = extension == ".cs"
            search_active = not skip_using
            line_number = 0
            term_matches: dict[str, list[tuple[int, str]]] = {term: [] for term in terms}

            try:
                with open(file_path, encoding="utf-8", errors="ignore") as handle:
                    for line in handle:
                        line_number += 1

                        if skip_using and line.strip().startswith("using "):
                            continue
                        if skip_using:
                            search_active = True
                            skip_using = False

                        if not search_active:
                            continue

                        for term in terms:
                            escaped = re.escape(term)
                            if not re.search(escaped, line):
                                continue
                            if calls and not re.search(r"\." + escaped, line):
                                continue

                            if cross:
                                term_matches[term].append((line_number, line))
                                continue

                            if not printed_name:
                                print_header(file_path)
                                printed_name = True
                            print(f"{line_number}\t{line.strip()}")
                            results_count += 1
                            if not uncapped and results_count >= MAX_RESULTS:
                                cap_reached = True
                                break
                        if cap_reached:
                            break
            except OSError as error:
                print(f"An error occurred while processing {file_path}: {error}", file=sys.stderr)
                continue

            if cross and all(term_matches.values()):
                print_header(file_path)
                for matches in term_matches.values():
                    for number, content in matches:
                        print(f"{number}\t{content.strip()}")
                results_count += 1
                if not uncapped and results_count >= MAX_RESULTS:
                    cap_reached = True
                    break


def main() -> int:
    parser = argparse.ArgumentParser(description="Search for patterns in files.")
    parser.add_argument("extension", help="File extension to search (e.g. .cs).")
    parser.add_argument("terms", nargs="+", help="Terms to search for.")
    parser.add_argument("--uncapped", action="store_true", help="List more than the limit of 3000 results.")
    parser.add_argument("--cross", action="store_true", help="Only search files that have all of the terms.")
    parser.add_argument("--dir", action="store_true", help="Display full file paths, not just file names.")
    parser.add_argument("--calls", action="store_true", help="Only match when a period precedes the term.")
    args = parser.parse_args()

    search_match(args.extension, args.terms, args.uncapped, args.cross, args.dir, args.calls)
    return 0


if __name__ == "__main__":
    sys.exit(main())
