#!/usr/bin/env python3
"""Generate a SQL script to search for a column name across a database."""

from __future__ import annotations

import argparse
import sys

MAGENTA = "\033[95m"
RESET = "\033[0m"

TEMPLATE = """\
WITH ColumnEntries AS (
    SELECT
        C.TABLE_SCHEMA,
        C.TABLE_NAME,
        C.COLUMN_NAME,
        COUNT(*) AS EntryCount
    FROM
        INFORMATION_SCHEMA.COLUMNS C
    JOIN
        INFORMATION_SCHEMA.TABLES T
    ON
        C.TABLE_NAME = T.TABLE_NAME
        AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
    WHERE
        C.COLUMN_NAME LIKE '%{column}%'
        AND T.TABLE_TYPE = 'BASE TABLE'
    GROUP BY
        C.TABLE_SCHEMA, C.TABLE_NAME, C.COLUMN_NAME
)
SELECT
    C.TABLE_SCHEMA AS SchemaName,
    C.TABLE_NAME AS TableName,
    C.COLUMN_NAME AS ColumnName,
    CASE
        WHEN E.EntryCount > 0 THEN 'True'
        ELSE 'False'
    END AS HasEntries
FROM
    INFORMATION_SCHEMA.COLUMNS C
LEFT JOIN
    ColumnEntries E
ON
    C.TABLE_SCHEMA = E.TABLE_SCHEMA
    AND C.TABLE_NAME = E.TABLE_NAME
    AND C.COLUMN_NAME = E.COLUMN_NAME
WHERE
    C.COLUMN_NAME LIKE '%{column}%'
ORDER BY
    SchemaName;
"""


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate SQL to find a column by name.")
    parser.add_argument("-c", "--column", required=True, help="Column name (or fragment) to search for.")
    args = parser.parse_args()

    print(f"{MAGENTA}{TEMPLATE.format(column=args.column)}{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
