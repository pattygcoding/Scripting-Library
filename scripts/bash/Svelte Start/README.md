# Svelte Start

Start a Svelte development server using Windows Terminal or PowerShell and open in browser.

## Description

This script provides a convenient way to start a Svelte development server and automatically open the application in a web browser. It's optimized for Windows environments, using Windows Terminal when available, and supports multiple browser options for opening the application.

## Dependencies

- Node.js and npm
- Svelte project with `npm run dev` script configured
- Windows Terminal (`wt.exe`) or PowerShell
- Chrome browser (`chrome.exe`) or alternative browser commands (`xdg-open`, `start`)

## Usage

```bash
svelte-start
```

## How it works

1. **Terminal Selection**: Prefers Windows Terminal (`wt.exe`) over regular PowerShell
2. **Server Start**: Runs `npm run dev` in the selected terminal
3. **Browser Launch**: Opens the application URL using the best available browser command
4. **Port Configuration**: Uses port 5173 (Vite's default for Svelte)

## Example

```bash
# Navigate to your Svelte project directory
cd my-svelte-app

# Start the development server
svelte-start
```

**Result:**
- New terminal window opens running `npm run dev`
- Browser opens to `http://localhost:5173/`

## Terminal Behavior

**With Windows Terminal available:**
```bash
wt.exe powershell.exe -NoExit -Command "npm run dev"
```
- Opens in new Windows Terminal tab
- PowerShell session remains open after command

**Without Windows Terminal:**
```bash
powershell.exe -NoExit -Command "npm run dev" &
```
- Opens in new PowerShell window
- Runs in background

## Browser Selection

The script tries browsers in this order:
1. **Chrome** (`chrome.exe`) - Preferred for development
2. **xdg-open** (Linux compatibility)  
3. **start** (Windows fallback)

## Port Configuration

- **Default Port**: 5173 (Vite development server)
- **URL Format**: `http://localhost:5173/`
- **Port Conflicts**: Vite will automatically use next available port if 5173 is busy

## Project Requirements

Your Svelte project should have the standard development script in `package.json`:

```json
{
  "scripts": {
    "dev": "vite dev"
  }
}
```

## Development Workflow

```bash
# Clone or navigate to Svelte project
cd my-svelte-project

# Install dependencies (if needed)
npm install

# Start development server and browser
svelte-start

# Begin coding - changes will hot-reload in browser
```

## Windows Terminal Benefits

**When Windows Terminal is available:**
- ✅ Better terminal experience
- ✅ Modern terminal features
- ✅ Improved text rendering
- ✅ Tab management
- ✅ Theme support

**PowerShell fallback:**
- ✅ Works on all Windows systems
- ✅ Reliable command execution
- ✅ Background process support

## Browser Compatibility

**Chrome advantages for development:**
- ✅ Excellent developer tools
- ✅ Svelte DevTools support
- ✅ Modern JavaScript features
- ✅ Hot reload compatibility

## Use Cases

- Quick Svelte development setup
- Automated development environment initialization
- Demo and presentation preparation
- Integration with development scripts
- Streamlined coding workflow

## Troubleshooting

**Terminal doesn't open:**
- Verify PowerShell is available
- Check Windows Terminal installation
- Ensure script has execution permissions

**Browser doesn't open:**
- Check if Chrome is installed and in PATH
- Verify alternative browsers (`xdg-open`, `start`)
- Manually open `http://localhost:5173/`

**Development server fails:**
- Ensure you're in a Svelte project directory
- Run `npm install` to install dependencies
- Check `package.json` for correct dev script
- Verify Node.js and npm are installed

## Notes

- Script is optimized for Windows development environments
- Terminal remains open with `-NoExit` flag for debugging
- Background process (`&`) used when Windows Terminal not available
- Port 5173 is Vite's default for Svelte (different from other frameworks)
- Hot module reloading works automatically with proper Svelte setup