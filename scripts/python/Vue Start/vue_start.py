#!/usr/bin/env python3
"""Start a Vue development server and open it in the browser."""

from __future__ import annotations

import argparse
import subprocess
import sys
import webbrowser

DEFAULT_PORT = 5173
DEFAULT_COMMAND = "npm run dev"


def main() -> int:
    parser = argparse.ArgumentParser(description="Start a Vue dev server and open it in Chrome.")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help="Dev server port (default: 5173).")
    parser.add_argument("--command", default=DEFAULT_COMMAND, help="Command to run (default: 'npm run dev').")
    args = parser.parse_args()

    subprocess.Popen(args.command, shell=True)
    webbrowser.open(f"http://localhost:{args.port}/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
