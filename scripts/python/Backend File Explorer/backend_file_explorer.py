import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import os
import win32com.client

EXTENSIONS = ['.cs', '.c', '.java', '.dart', '.vue', '.php', '.ts', '.js', ".py", '.html', '.css', '.json', '.xml', '.cpp']
DEFAULT_EXTENSION = EXTENSIONS[0]

IGNORE_DIRS = ['node_modules', '.git', 'build', 'dist', 'vendor', '__pycache__']

INDEX_PATH = r'' # Insert your cache location here
PROJECT_ROOT = os.path.dirname(os.path.dirname(INDEX_PATH))

VSCODE_CMD = 'code'
ANDROID_STUDIO_CMD = r'' # Android Studio exe location

EDITORS = ['Visual Studio', 'VS Code', 'Android Studio']
DEFAULT_EDITOR = EDITORS[0]

current_suggestions = []

def load_index():
    index = {}

    if not os.path.exists(INDEX_PATH):
        messagebox.showerror('Error', f'Index file not found:\n{INDEX_PATH}')
    else:
        with open(INDEX_PATH, 'r', encoding='utf-8') as f:
            for line in f:
                if '|' not in line:
                    continue
                name, dirs = line.strip().split('|', 1)
                cs_name = f"{name}.cs"
                paths = []
                for d in dirs.split(';'):
                    d = d.strip()
                    full = os.path.join(d, cs_name)
                    if os.path.isfile(full):
                        paths.append(full)
                if paths:
                    index[cs_name] = paths

    for dirpath, dirnames, filenames in os.walk(PROJECT_ROOT):
        dirnames[:] = [d for d in dirnames if d not in IGNORE_DIRS]
        for fname in filenames:
            lower = fname.lower()
            for ext in EXTENSIONS[1:]:
                if lower.endswith(ext):
                    full = os.path.join(dirpath, fname)
                    index.setdefault(fname, []).append(full)
    return index


def open_in_visual_studio(paths):
    try:
        dte = win32com.client.GetActiveObject('VisualStudio.DTE.17.0')
        for p in paths:
            dte.ItemOperations.OpenFile(p)
    except Exception:
        existing = [p for p in paths if os.path.exists(p)]
        if existing:
            subprocess.run(['devenv.exe', '/Edit'] + existing)


def open_in_vscode(paths):
    existing = [p for p in paths if os.path.exists(p)]
    if existing:
        subprocess.run([VSCODE_CMD, '-g'] + existing)


def open_in_android_studio(paths):
    existing = [p for p in paths if os.path.exists(p)]
    if existing and os.path.isfile(ANDROID_STUDIO_CMD):
        subprocess.run([ANDROID_STUDIO_CMD] + existing)


def open_files(paths):
    editor = editor_var.get()
    if editor == 'Visual Studio':
        open_in_visual_studio(paths)
    elif editor == 'VS Code':
        open_in_vscode(paths)
    elif editor == 'Android Studio':
        open_in_android_studio(paths)


def on_open(event=None):
    sel = entry_var.get()
    if sel not in file_map:
        messagebox.showwarning('Error', f"'{sel}' is not valid.")
        status_var.set(f"Error: '{sel}' not found")
        return 'break'

    paths = [p for p in file_map[sel] if os.path.exists(p)]
    if not paths:
        messagebox.showerror('Not Found', f"No file on disk for '{sel}'.")
        status_var.set(f"No file for '{sel}'")
        return 'break'

    open_files(paths)
    status_var.set(f"Opened {sel} in {editor_var.get()}")
    hide_list()
    return 'break'


def show_list(items):
    listbox.delete(0, tk.END)
    for it in items:
        listbox.insert(tk.END, it)
    list_frame.pack(padx=20, fill='both', pady=(0,5))


def hide_list():
    list_frame.pack_forget()


def on_click(event):
    global current_suggestions
    ext = file_type_var.get()
    current_suggestions = sorted(k for k in file_map if k.lower().endswith(ext))
    show_list(current_suggestions)


def on_keyrelease(event):
    global current_suggestions
    typed = entry_var.get().lower()
    ext = file_type_var.get()
    all_names = sorted(k for k in file_map if k.lower().endswith(ext))
    prefix = [n for n in all_names if n.lower().startswith(typed)]
    contains = [n for n in all_names if typed in n.lower() and not n.lower().startswith(typed)]
    current_suggestions = prefix + contains
    if current_suggestions:
        show_list(current_suggestions)
    else:
        hide_list()


def on_listbox_select(event):
    sel = event.widget.curselection()
    if not sel:
        return
    entry_var.set(event.widget.get(sel[0]))
    hide_list()
    entry.icursor(tk.END)
    entry.focus_set()


def accept_autocomplete(event):
    if current_suggestions:
        first = current_suggestions[0]
        entry_var.set(first)
        entry.icursor(len(first))
        entry.select_range(len(event.widget.get()), len(first))
        hide_list()
    return 'break'


def center_window(win, width=400, height=700):
    sw, sh = win.winfo_screenwidth(), win.winfo_screenheight()
    x, y = (sw-width)//2, (sh-height)//2
    win.geometry(f"{width}x{height}+{x}+{y}")

file_map = load_index()

root = tk.Tk()
root.title('Multi-Ext File Opener')
center_window(root)
root.resizable(True, True)

file_type_var = tk.StringVar(value=DEFAULT_EXTENSION)
file_type_dropdown = ttk.Combobox(
    root, textvariable=file_type_var,
    values=EXTENSIONS, state='readonly', width=6
)
file_type_dropdown.pack(pady=(15,5))

editor_var = tk.StringVar(value=DEFAULT_EDITOR)
editor_dropdown = ttk.Combobox(
    root, textvariable=editor_var,
    values=EDITORS, state='readonly', width=15
)
editor_dropdown.pack(pady=(0,10))

entry_var = tk.StringVar()
entry = tk.Entry(root, textvariable=entry_var)
entry.pack(padx=20, fill='x')
entry.bind('<Button-1>',   on_click)
entry.bind('<KeyRelease>', on_keyrelease)
entry.bind('<Tab>',        accept_autocomplete)
entry.bind('<Return>',     on_open)

list_frame = tk.Frame(root)
scroll     = tk.Scrollbar(list_frame, orient=tk.VERTICAL)
listbox    = tk.Listbox(list_frame, yscrollcommand=scroll.set, height=20)
scroll.config(command=listbox.yview)
scroll.pack(side=tk.RIGHT, fill=tk.Y)
listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
list_frame.pack_forget()
listbox.bind('<<ListboxSelect>>', on_listbox_select)

status_var   = tk.StringVar()
status_label = tk.Label(root, textvariable=status_var, fg='green')
status_label.pack(fill='x', pady=(0,5), padx=20)

open_btn = tk.Button(root, text='Open File', command=on_open)
open_btn.pack(side=tk.BOTTOM, pady=15)

root.mainloop()
