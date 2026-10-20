# Vue Start

Start a Vue development server and automatically open the application in the default browser.

## Description

This script provides a convenient way to start a Vue development server on the default port (5173) and automatically launch the application in your default web browser. It streamlines the Vue development workflow by combining server startup and browser opening into a single command.

## Dependencies

- Node.js and npm
- Vue project with `npm run dev` script configured
- `xdg-open` (Linux) or `open` (macOS) command for browser launching

## Usage

```bash
vue-start
```

## How it works

1. Starts the Vue development server using `npm run dev` in the background
2. Waits 2 seconds for the server to initialize
3. Automatically opens `http://localhost:5173` in the default browser

## Example

```bash
# Navigate to your Vue project directory
cd my-vue-application

# Start the development server
vue-start
```

**Output:**
```
Starting Vue app on port 5173...
```

The browser will automatically open to `http://localhost:5173` where your Vue application will be running.

## Project Requirements

Your Vue project should have the standard development script in `package.json`:

```json
{
  "scripts": {
    "dev": "vite dev"
  }
}
```

**Vue CLI projects** may use:
```json
{
  "scripts": {
    "serve": "vue-cli-service serve"
  }
}
```

## Port Configuration

- **Default Port**: 5173 (Vite's default for Vue 3)
- **Vue CLI**: Uses port 8080 by default  
- **Port Conflicts**: Development server will automatically use next available port if default is busy
- **Vite Projects**: Most modern Vue projects use Vite, which defaults to port 5173

## Framework Versions

**Vue 3 (Vite-based projects):**
- Default port: 5173
- Command: `npm run dev`
- Fast HMR (Hot Module Replacement)

**Vue 2 (Vue CLI projects):**  
- Default port: 8080
- Command: `npm run serve` (may need script modification)
- Traditional webpack dev server

## Development Workflow

```bash
# Clone or navigate to Vue project
cd my-vue-project

# Install dependencies (if needed)
npm install

# Start development server and browser
vue-start

# Begin coding - changes will hot-reload in browser
```

## Browser Compatibility

The script attempts to open the browser using:
1. `xdg-open` (Linux systems)
2. `open` (macOS systems)  
3. Falls back gracefully if neither command is available

## Use Cases

- Quick Vue development environment setup
- Automated development workflow initialization
- Demo and presentation preparation
- Integration with development scripts
- Streamlined coding workflow

## Hot Module Replacement (HMR)

**Vite-based Vue projects benefit from:**
- ✅ **Instant updates**: Changes reflect immediately
- ✅ **State preservation**: Component state maintained during updates
- ✅ **Fast rebuilds**: Only changed modules are updated
- ✅ **CSS hot reload**: Stylesheet changes update without page refresh

## Troubleshooting

**Server doesn't start:**
- Ensure you're in a Vue project directory
- Check `package.json` for correct dev script
- Run `npm install` to install dependencies
- Verify Node.js and npm are installed

**Browser doesn't open:**
- Check if `xdg-open` (Linux) or `open` (macOS) is available
- Manually navigate to `http://localhost:5173`
- Verify the development server started successfully

**Wrong port displayed:**
- Script assumes port 5173 but Vue may use different port
- Check terminal output for actual port being used
- Manually open the correct port in browser

**Vue CLI projects:**
You may need to modify the script to use:
```bash
(npm run serve &)  # instead of npm run dev
```

## Customization

**For Vue CLI projects (port 8080):**
```bash
vue-start() {
    local port=8080  # Change to 8080
    echo -e "\033[33mStarting Vue app on port $port...\033[0m"
    (npm run serve &)  # Change to serve
    sleep 2
    xdg-open "http://localhost:$port" > /dev/null 2>&1 || open "http://localhost:$port"
}
```

## Notes

- Script assumes Vite-based Vue project (most modern Vue 3 projects)
- Development server runs in background, allowing continued terminal use
- Hot reloading works automatically for supported file types
- Use `Ctrl+C` in terminal to stop the development server
- Browser opens automatically but requires manual navigation if port changes
- Compatible with Vue 3 projects using Vite build tool