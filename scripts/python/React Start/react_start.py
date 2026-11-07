#!/usr/bin/env python3
"""Start a React development server and open it in the browser."""

from __future__ import annotations

import argparse
import subprocess
import sys
import webbrowser

DEFAULT_PORT = 3000
DEFAULT_COMMAND = "npm start"


def main() -> int:
    parser = argparse.ArgumentParser(description="Start a React dev server and open it in Chrome.")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help="Dev server port (default: 3000).")
    parser.add_argument("--command", default=DEFAULT_COMMAND, help="Command to run (default: 'npm start').")
    args = parser.parse_args()

    subprocess.Popen(args.command, shell=True)
    webbrowser.open(f"http://localhost:{args.port}/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
