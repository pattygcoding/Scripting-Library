# Angular Start

Start an Angular development server and automatically open the application in the default browser.

## Description

This script provides a simple way to start an Angular development server on the default port (4200) and automatically launch the application in your default web browser. It's designed to streamline the development workflow for Angular projects.

## Dependencies

- Angular CLI (`ng` command)
- `xdg-open` (Linux) or `open` (macOS) command for browser launching

## Usage

```bash
angular-start
```

## How it works

1. Starts the Angular development server using `ng serve` in the background
2. Waits 2 seconds for the server to initialize
3. Automatically opens `http://localhost:4200` in the default browser

## Example

```bash
# Navigate to your Angular project directory
cd my-angular-project

# Start the development server
angular-start
```

**Output:**
```
Starting Angular app on port 4200...
```

The browser will automatically open to `http://localhost:4200` where your Angular application will be running.

## Notes

- Make sure you're in an Angular project directory before running this command
- The script uses the default Angular CLI port (4200)
- If port 4200 is already in use, Angular CLI will automatically use the next available port
- The development server runs in the background, allowing you to continue using the terminal