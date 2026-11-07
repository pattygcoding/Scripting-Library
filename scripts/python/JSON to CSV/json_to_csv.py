#!/usr/bin/env python3
"""Convert a JSON file (a list of objects) into a CSV file."""

from __future__ import annotations

import argparse
import csv
import json
import sys


def json_to_csv(json_file: str, csv_file: str) -> None:
    """Read *json_file* and write its rows to *csv_file*."""
    with open(json_file, encoding="utf-8") as handle:
        data = json.load(handle)

    if not data:
        raise ValueError("the JSON file contains no rows")

    fieldnames = list(data[0].keys())
    with open(csv_file, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert a JSON file to CSV.")
    parser.add_argument("json_file", nargs="?", default="data.json", help="Input JSON file.")
    parser.add_argument("csv_file", nargs="?", default="data.csv", help="Output CSV file.")
    args = parser.parse_args()

    try:
        json_to_csv(args.json_file, args.csv_file)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    print(f"Wrote {args.csv_file}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
