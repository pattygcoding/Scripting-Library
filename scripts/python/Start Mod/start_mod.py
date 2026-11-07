#!/usr/bin/env python3
"""Build and launch a Minecraft mod client via Gradle."""

from __future__ import annotations

import argparse
import subprocess
import sys


def gradlew_command() -> str:
    """Return the platform-appropriate Gradle wrapper command."""
    return "gradlew.bat" if sys.platform == "win32" else "./gradlew"


def main() -> int:
    parser = argparse.ArgumentParser(description="Build and launch a Minecraft mod client.")
    parser.add_argument("--skip-build", action="store_true", help="Skip 'gradlew clean build'.")
    args = parser.parse_args()

    gradlew = gradlew_command()

    if not args.skip_build:
        subprocess.run([gradlew, "clean", "build"], check=False)
    subprocess.run([gradlew, "runClient"], check=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
