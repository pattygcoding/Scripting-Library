# India Time

Convert local time to India timezone (IST) or display current India time.

## Description

This script provides timezone conversion functionality specifically for India Standard Time (IST). It can display the current time in India or convert a specified local time to the corresponding time in India.

## Dependencies

- `date` command with timezone support
- UTC timezone calculation capability

## Parameters

- `$1` - **Time in HH:MM AM/PM format** (optional): Local time to convert to India time

## Usage

```bash
india-time [time]
```

## How it works

1. **Without parameters**: Shows the current time in India
2. **With time parameter**: 
   - Parses the input time format (HH:MM AM/PM)
   - Converts the local time to UTC
   - Applies India's timezone offset (+05:30)
   - Displays the converted time

## Examples

```bash
# Show current India time
india-time
```
**Output:**
```
Current time in India: 02:30 PM
```

```bash
# Convert specific time to India time
india-time "9:00 AM"
```
**Output:**
```
Inputted time in India: 02:30 PM
```

```bash
# Convert evening time
india-time "8:45 PM"
```
**Output:**
```
Inputted time in India: 02:15 PM
```

## Supported Time Formats

The script accepts time in the following formats:
- `H:MM AM/PM` (e.g., "9:30 AM", "2:15 PM")
- `HH:MM AM/PM` (e.g., "09:30 AM", "02:15 PM")
- Case insensitive AM/PM (am, pm, AM, PM)

## Timezone Information

- **India Standard Time (IST)**: UTC +05:30
- **No Daylight Saving Time**: India does not observe DST
- **Single Timezone**: All of India follows the same timezone

## Error Handling

The script provides error messages for:
- Invalid time format
- Unparseable time strings

**Example Error:**
```bash
india-time "25:00 AM"
# Output: Failed to parse time.

india-time "not a time"
# Output: Invalid time format. Use format like '8:26 AM'.
```

## Use Cases

- Converting meeting times for international teams
- Scheduling calls with Indian colleagues or clients
- Planning travel itineraries
- Coordinating events across timezones
- Quick timezone reference for India

## Notes

- The script assumes your local time is in your system's configured timezone
- India Standard Time is 5 hours and 30 minutes ahead of UTC
- The conversion is based on your system's current date
- Output format is 12-hour format with AM/PM
- No internet connection required - uses local system time calculations