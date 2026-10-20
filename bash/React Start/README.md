# React Start

Start a React development server and automatically open the application in the default browser.

## Description

This script provides a convenient way to start a React development server on the default port (3000) and automatically launch the application in your default web browser. It streamlines the React development workflow by combining server startup and browser opening into a single command.

## Dependencies

- Node.js and npm
- React project with `npm start` script configured
- `xdg-open` (Linux) or `open` (macOS) command for browser launching

## Usage

```bash
react-start
```

## How it works

1. Starts the React development server using `npm start` in the background
2. Waits 2 seconds for the server to initialize
3. Automatically opens `http://localhost:3000` in the default browser

## Example

```bash
# Navigate to your React project directory
cd my-react-application

# Start the development server
react-start
```

**Output:**
```
Starting React app on port 3000...
```

The browser will automatically open to `http://localhost:3000` where your React application will be running.

## Project Requirements

Your React project should have the standard `npm start` script in `package.json`:

```json
{
  "scripts": {
    "start": "react-scripts start"
  }
}
```

## Port Configuration

- **Default Port**: 3000 (React's standard development port)
- **Port Conflicts**: If port 3000 is busy, Create React App will automatically use the next available port
- **Custom Ports**: The script assumes port 3000, but React will notify you if using a different port

## Use Cases

- Quick development server startup
- Automated development environment setup
- Integration with development scripts
- Streamlined coding workflow
- Demo and presentation preparation

## Browser Compatibility

The script attempts to open the browser using:
1. `xdg-open` (Linux systems)
2. `open` (macOS systems)
3. Falls back gracefully if neither command is available

## Development Workflow

```bash
# Clone or navigate to React project
cd my-react-project

# Install dependencies (if needed)
npm install

# Start development server
react-start

# Begin coding - changes will auto-reload in browser
```

## Notes

- Ensure you're in a React project directory before running
- The development server runs in the background
- Hot reloading will work automatically for code changes
- Use `Ctrl+C` in the terminal to stop the development server
- The script works with Create React App and similar React setups
- Browser opens automatically but won't refresh if there are compilation errors