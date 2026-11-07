#!/usr/bin/env python3
"""Convert a time to India Standard Time (IST).

With no input it prints the current time in India; pass a local time such as
"8:26 AM" to convert it.
"""

from __future__ import annotations

import argparse
import sys
from datetime import datetime, timedelta, timezone

IST_OFFSET_HOURS = 5.5
TIME_FORMAT = "%I:%M %p"


def to_ist(moment: datetime) -> datetime:
    """Return *moment* converted to India Standard Time."""
    if moment.tzinfo is None:
        moment = moment.astimezone()
    return moment.astimezone(timezone(timedelta(hours=IST_OFFSET_HOURS)))


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert a time to India Standard Time.")
    parser.add_argument("time", nargs="?", help="Local time to convert, e.g. '8:26 AM' (default: now).")
    args = parser.parse_args()

    try:
        if args.time:
            local = datetime.strptime(args.time, TIME_FORMAT)
            print(f"Inputted time in India: {to_ist(local).strftime(TIME_FORMAT)}")
        else:
            print(f"Current time in India: {to_ist(datetime.now()).strftime(TIME_FORMAT)}")
    except ValueError:
        print("Invalid time format. Use format like '8:26 AM'.", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
