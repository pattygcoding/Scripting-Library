#!/usr/bin/env python3
"""Start an Angular development server and open it in the browser."""

from __future__ import annotations

import argparse
import subprocess
import sys
import webbrowser

DEFAULT_PORT = 4200
DEFAULT_COMMAND = "ng serve"


def main() -> int:
    parser = argparse.ArgumentParser(description="Start an Angular dev server and open it in Chrome.")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help="Dev server port (default: 4200).")
    parser.add_argument("--command", default=DEFAULT_COMMAND, help="Command to run (default: 'ng serve').")
    args = parser.parse_args()

    subprocess.Popen(args.command, shell=True)
    webbrowser.open(f"http://localhost:{args.port}/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
