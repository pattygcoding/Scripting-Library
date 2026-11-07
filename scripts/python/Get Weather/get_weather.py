#!/usr/bin/env python3
"""Print the current weather for a city.

Uses the OpenWeatherMap API and requires the third-party package ``requests``.
Supply a key with --api-key or the OPENWEATHER_API_KEY environment variable.
"""

from __future__ import annotations

import argparse
import os
import sys

import requests

API_URL = "http://api.openweathermap.org/data/2.5/weather"


def get_weather(city: str, api_key: str, timeout: int = 30) -> dict:
    """Return the OpenWeatherMap JSON payload for *city*."""
    response = requests.get(
        API_URL,
        params={"q": city, "appid": api_key, "units": "metric"},
        timeout=timeout,
    )
    response.raise_for_status()
    return response.json()


def main() -> int:
    parser = argparse.ArgumentParser(description="Return the weather for a city.")
    parser.add_argument("city", nargs="?", default="London", help="City name (default: London).")
    parser.add_argument(
        "--api-key",
        default=os.environ.get("OPENWEATHER_API_KEY", ""),
        help="OpenWeatherMap API key (default: $OPENWEATHER_API_KEY).",
    )
    args = parser.parse_args()

    if not args.api_key:
        print("Error: provide an API key with --api-key or OPENWEATHER_API_KEY.", file=sys.stderr)
        return 1

    try:
        data = get_weather(args.city, args.api_key)
    except requests.RequestException as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    if str(data.get("cod")) != "200":
        print(f"Error: {data.get('message', 'request failed')}", file=sys.stderr)
        return 1

    main_block = data["main"]
    wind = data["wind"]
    description = data["weather"][0]["description"]

    print(f"Temperature: {main_block['temp']}°C")
    print(f"Humidity: {main_block['humidity']}%")
    print(f"Wind Speed: {wind['speed']} m/s")
    print(f"Description: {description}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
