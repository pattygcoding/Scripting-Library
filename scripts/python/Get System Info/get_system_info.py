#!/usr/bin/env python3
"""Print system information for the current machine.

Requires the third-party package ``psutil``.
"""

from __future__ import annotations

import platform
import socket
import sys

import psutil


def get_system_info() -> dict[str, str]:
    """Return a mapping of system-information labels to values."""
    try:
        ip_address = socket.gethostbyname(socket.gethostname())
    except OSError:
        ip_address = "unknown"

    return {
        "platform": platform.system(),
        "platform-release": platform.release(),
        "platform-version": platform.version(),
        "architecture": platform.machine(),
        "hostname": platform.node(),
        "ip-address": ip_address,
        "processor": platform.processor(),
        "ram": f"{round(psutil.virtual_memory().total / (1024 ** 3))} GB",
    }


def main() -> int:
    for key, value in get_system_info().items():
        print(f"{key}: {value}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
