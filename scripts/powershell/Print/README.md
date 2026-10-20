## Print
Enhanced Write-Host function with color support and parameter flexibility. Allows colored output with foreground/background colors.

### Parameters
- `-Object`: Objects to print (accepts multiple values)
- `-ForegroundColor`: Text color
- `-BackgroundColor`: Background color
- `-NoNewline`: Switch to suppress newline

### Example Usage
```powershell
print "Hello World" -ForegroundColor Red
print "Text" -BackgroundColor Blue -NoNewline
```