#!/usr/bin/env python3
"""Read text out of PNG images with OCR.

Reads every PNG in a "PicturesToRead" folder (override with a path argument) and
prints the recognised text. Requires the third-party package ``easyocr``.
"""

from __future__ import annotations

import argparse
import os
import sys


def read_images(folder: str) -> int:
    """OCR every PNG in *folder*, printing each result. Returns the count read."""
    import easyocr

    reader = easyocr.Reader(["en"])
    processed = 0

    for filename in sorted(os.listdir(folder)):
        if not filename.lower().endswith(".png"):
            continue

        file_path = os.path.join(folder, filename)
        try:
            lines = reader.readtext(file_path, detail=0)
        except Exception as error:  # easyocr raises a variety of errors
            print(f"Error reading {filename}: {error}", file=sys.stderr)
            continue

        print(f"\n===== {filename} =====")
        for line in lines:
            print(line)
        processed += 1

    return processed


def main() -> int:
    parser = argparse.ArgumentParser(description="OCR text out of PNG images.")
    parser.add_argument("folder", nargs="?", default="PicturesToRead", help="Folder of PNGs (default: PicturesToRead).")
    args = parser.parse_args()

    if not os.path.isdir(args.folder):
        print(f"Error: folder not found: {args.folder}", file=sys.stderr)
        return 1

    read_images(args.folder)
    return 0


if __name__ == "__main__":
    sys.exit(main())
