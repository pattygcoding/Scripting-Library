#!/usr/bin/env python3
"""Generate a random password."""

from __future__ import annotations

import argparse
import secrets
import string
import sys

ALPHABET = string.ascii_letters + string.digits + string.punctuation
DEFAULT_LENGTH = 12


def generate_password(length: int = DEFAULT_LENGTH) -> str:
    """Return a random password of the requested length."""
    return "".join(secrets.choice(ALPHABET) for _ in range(length))


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate a random password.")
    parser.add_argument("-l", "--length", type=int, default=DEFAULT_LENGTH, help="Password length (default: 12).")
    args = parser.parse_args()

    if args.length < 1:
        parser.error("length must be a positive integer")

    print("Generated password:", generate_password(args.length))
    return 0


if __name__ == "__main__":
    sys.exit(main())
