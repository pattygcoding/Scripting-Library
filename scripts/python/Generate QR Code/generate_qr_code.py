#!/usr/bin/env python3
"""Generate a QR code image from text or a URL.

Requires the third-party package ``qrcode`` (and ``pillow`` for PNG output).
"""

from __future__ import annotations

import argparse
import sys

import qrcode


def generate_qr_code(data: str, file_path: str) -> None:
    """Write a QR code encoding *data* to *file_path*."""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)
    qr.make_image(fill_color="black", back_color="white").save(file_path)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate a QR code for a link or text.")
    parser.add_argument("data", nargs="?", default="https://www.example.com", help="Text or URL to encode.")
    parser.add_argument("-o", "--output", default="qrcode.png", help="Output image path (default: qrcode.png).")
    args = parser.parse_args()

    generate_qr_code(args.data, args.output)
    print(f"QR code written to {args.output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
