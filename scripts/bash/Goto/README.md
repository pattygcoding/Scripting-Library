# Goto

Jump to a frequently used directory, configured in the function's `destinations` map.

## Parameters

- `$1` - Destination key to navigate to

## Usage

```bash
goto <destination>
```

## Setup

Edit the `destinations` associative array in `goto.sh` and add your own paths.

## Example

```bash
goto repos
# Output: Navigated to /home/user/repos
```
