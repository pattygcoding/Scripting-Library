#!/usr/bin/env python3
"""Merge several PDF files into one.

Requires the third-party package ``pypdf`` (older installs may provide
``PyPDF2`` instead).
"""

from __future__ import annotations

import argparse
import sys

try:
    from pypdf import PdfMerger
except ImportError:  # pragma: no cover - fallback for older installs
    from PyPDF2 import PdfMerger


def merge_pdfs(pdf_files: list[str], output: str) -> None:
    """Concatenate *pdf_files*, in order, into *output*."""
    merger = PdfMerger()
    try:
        for pdf in pdf_files:
            merger.append(pdf)
        merger.write(output)
    finally:
        merger.close()


def main() -> int:
    parser = argparse.ArgumentParser(description="Merge multiple PDFs into one.")
    parser.add_argument("pdfs", nargs="+", help="PDF files to merge, in order.")
    parser.add_argument("-o", "--output", default="merged.pdf", help="Output file (default: merged.pdf).")
    args = parser.parse_args()

    try:
        merge_pdfs(args.pdfs, args.output)
    except OSError as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    print(f"Merged {len(args.pdfs)} files into {args.output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
