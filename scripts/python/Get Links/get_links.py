#!/usr/bin/env python3
"""Print the links found on a web page.

Requires the third-party packages ``requests`` and ``beautifulsoup4``.
"""

from __future__ import annotations

import argparse
import sys

import requests
from bs4 import BeautifulSoup


def get_links(url: str, timeout: int = 30) -> list[str]:
    """Return every ``href`` found in the HTML at *url*."""
    response = requests.get(url, timeout=timeout)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, "html.parser")
    return [anchor["href"] for anchor in soup.find_all("a", href=True)]


def main() -> int:
    parser = argparse.ArgumentParser(description="Return the links inside a URL.")
    parser.add_argument("url", nargs="?", default="https://example.com", help="The page to scan.")
    args = parser.parse_args()

    try:
        links = get_links(args.url)
    except requests.RequestException as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    for link in links:
        print(link)
    return 0


if __name__ == "__main__":
    sys.exit(main())
