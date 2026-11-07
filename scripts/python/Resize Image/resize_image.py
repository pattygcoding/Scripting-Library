#!/usr/bin/env python3
"""Resize an image.

Requires the third-party package ``pillow``.
"""

from __future__ import annotations

import argparse
import sys

from PIL import Image


def resize_image(input_path: str, output_path: str, size: tuple[int, int]) -> None:
    """Resize the image at *input_path* to *size* and save it to *output_path*."""
    with Image.open(input_path) as image:
        image.resize(size).save(output_path)


def main() -> int:
    parser = argparse.ArgumentParser(description="Resize an image.")
    parser.add_argument("input", help="Input image path.")
    parser.add_argument("output", help="Output image path.")
    parser.add_argument("--width", type=int, default=800, help="Target width (default: 800).")
    parser.add_argument("--height", type=int, default=600, help="Target height (default: 600).")
    args = parser.parse_args()

    resize_image(args.input, args.output, (args.width, args.height))
    print(f"Image resized and saved to {args.output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
