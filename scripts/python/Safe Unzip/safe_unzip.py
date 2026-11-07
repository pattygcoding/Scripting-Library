#!/usr/bin/env python3
"""Safely extract a ZIP archive with zip-bomb and traversal protections."""

from __future__ import annotations

import argparse
import os
import sys
import zipfile

DEFAULT_MAX_FILES = 1000
DEFAULT_MAX_BYTES = 500 * 1024 * 1024


def is_unsafe(name: str) -> bool:
    """Return True when an entry name tries to escape the destination."""
    normalized = name.replace("\\", "/")
    return normalized.startswith("../") or "/../" in normalized or normalized in ("", ".")


def safe_unzip(zip_path: str, max_files: int = DEFAULT_MAX_FILES, max_bytes: int = DEFAULT_MAX_BYTES) -> str:
    """Validate and extract *zip_path*, returning the destination folder."""
    destination = os.path.join(
        os.path.dirname(os.path.abspath(zip_path)),
        os.path.splitext(os.path.basename(zip_path))[0] + "_unzipped",
    )
    os.makedirs(destination, exist_ok=True)

    with zipfile.ZipFile(zip_path) as archive:
        count = 0
        total = 0
        for entry in archive.infolist():
            if is_unsafe(entry.filename):
                raise ValueError(f"unsafe path detected in entry '{entry.filename}'")
            if entry.file_size > 0:
                count += 1
                total += entry.file_size
                if count > max_files:
                    raise ValueError(f"file count exceeds {max_files}")
                if total > max_bytes:
                    raise ValueError(f"total size exceeds {max_bytes // (1024 * 1024)} MB")
        archive.extractall(destination)

    return destination


def main() -> int:
    parser = argparse.ArgumentParser(description="Safely extract a ZIP archive.")
    parser.add_argument("zip_path", help="Path to the ZIP file to extract.")
    parser.add_argument("--max-file-count", type=int, default=DEFAULT_MAX_FILES, help="Maximum number of files.")
    parser.add_argument("--max-total-size", type=int, default=DEFAULT_MAX_BYTES, help="Maximum total bytes.")
    args = parser.parse_args()

    if not os.path.isfile(args.zip_path):
        print(f"Error: zip file not found: {args.zip_path}", file=sys.stderr)
        return 1

    try:
        destination = safe_unzip(args.zip_path, args.max_file_count, args.max_total_size)
    except (OSError, ValueError, zipfile.BadZipFile) as error:
        print(f"Extraction failed: {error}", file=sys.stderr)
        return 1

    print(f"Extracted to: {destination}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
