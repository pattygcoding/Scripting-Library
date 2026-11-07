#!/usr/bin/env python3
"""Generate a SQL script to count the entries in a table."""

from __future__ import annotations

import argparse
import sys

MAGENTA = "\033[95m"
RESET = "\033[0m"

TEMPLATE = """\
SELECT COUNT(*) AS total_entries
FROM {table};
"""


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate SQL to count a table's rows.")
    parser.add_argument("-t", "--table", required=True, help="Table name (optionally schema-qualified).")
    args = parser.parse_args()

    print(f"{MAGENTA}{TEMPLATE.format(table=args.table)}{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
