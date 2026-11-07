#!/usr/bin/env python3
"""Shorten a long URL with TinyURL.

Requires the third-party package ``requests``.
"""

from __future__ import annotations

import argparse
import sys

import requests

TINYURL_API = "http://tinyurl.com/api-create.php"


def shorten_url(long_url: str, timeout: int = 30) -> str:
    """Return the TinyURL short form of *long_url*."""
    response = requests.get(TINYURL_API, params={"url": long_url}, timeout=timeout)
    response.raise_for_status()
    return response.text.strip()


def main() -> int:
    parser = argparse.ArgumentParser(description="Shorten a URL.")
    parser.add_argument("url", nargs="?", default="https://www.example.com", help="The URL to shorten.")
    args = parser.parse_args()

    try:
        print(shorten_url(args.url))
    except requests.RequestException as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
