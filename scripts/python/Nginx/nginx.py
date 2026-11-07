#!/usr/bin/env python3
"""Start or reload a local Nginx server."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys

# Insert the path to your nginx installation here.
NGINX_BASE = r""


def is_running() -> bool:
    """Return True when an nginx process is running."""
    try:
        result = subprocess.run(
            ["tasklist", "/FI", "IMAGENAME eq nginx.exe"],
            capture_output=True, text=True, check=False,
        )
    except FileNotFoundError:
        return False
    return "nginx.exe" in result.stdout


def start_or_reload(base: str, exe: str, conf: str) -> None:
    """Reload nginx when it is running, otherwise start it."""
    if is_running():
        subprocess.Popen([exe, "-s", "reload"], cwd=base or None)
    else:
        subprocess.Popen([exe, "-c", conf], cwd=base or None)


def main() -> int:
    parser = argparse.ArgumentParser(description="Start or reload a local Nginx server.")
    parser.add_argument("--base", default=NGINX_BASE, help="Nginx installation directory.")
    args = parser.parse_args()

    exe = os.path.join(args.base, "nginx.exe")
    conf = os.path.join(args.base, "conf", "nginx.conf")

    if not args.base or not os.path.isfile(exe):
        print("Error: nginx not found. Set --base to your installation directory.", file=sys.stderr)
        return 1

    start_or_reload(args.base, exe, conf)
    return 0


if __name__ == "__main__":
    sys.exit(main())
