#!/usr/bin/env python3
"""Print the machine's IPv4 addresses."""

from __future__ import annotations

import socket
import sys


def get_ipv4_addresses() -> list[str]:
    """Return the host's IPv4 addresses."""
    try:
        hostname = socket.gethostname()
        infos = socket.getaddrinfo(hostname, None, socket.AF_INET)
    except socket.gaierror:
        return []
    return sorted({info[4][0] for info in infos})


def main() -> int:
    for address in get_ipv4_addresses():
        print(address)
    return 0


if __name__ == "__main__":
    sys.exit(main())
