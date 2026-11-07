#!/usr/bin/env python3
"""GUI file explorer that opens indexed files in an editor.

Pick a file extension, type a name (with autocomplete) and open the match in
Visual Studio, VS Code or Android Studio. Visual Studio integration uses the
Windows-only ``pywin32`` package.
"""

from __future__ import annotations

import os
import subprocess
import sys
import tkinter as tk
from tkinter import messagebox, ttk

EXTENSIONS = [
    ".cs", ".c", ".java", ".dart", ".vue", ".php", ".ts",
    ".js", ".py", ".html", ".css", ".json", ".xml", ".cpp",
]
DEFAULT_EXTENSION = EXTENSIONS[0]

IGNORE_DIRS = {"node_modules", ".git", "build", "dist", "vendor", "__pycache__"}

INDEX_PATH = r""  # Insert your cache location here
PROJECT_ROOT = os.path.dirname(os.path.dirname(INDEX_PATH))

VSCODE_CMD = "code"
ANDROID_STUDIO_CMD = r""  # Android Studio exe location

EDITORS = ["Visual Studio", "VS Code", "Android Studio"]


def load_index() -> dict[str, list[str]]:
    """Build a map of file name -> list of absolute paths on disk."""
    index: dict[str, list[str]] = {}

    if os.path.exists(INDEX_PATH):
        with open(INDEX_PATH, encoding="utf-8") as handle:
            for line in handle:
                if "|" not in line:
                    continue
                name, dirs = line.strip().split("|", 1)
                cs_name = f"{name}.cs"
                paths = []
                for directory in dirs.split(";"):
                    full = os.path.join(directory.strip(), cs_name)
                    if os.path.isfile(full):
                        paths.append(full)
                if paths:
                    index[cs_name] = paths

    for dirpath, dirnames, filenames in os.walk(PROJECT_ROOT or "."):
        dirnames[:] = [name for name in dirnames if name not in IGNORE_DIRS]
        for fname in filenames:
            if any(fname.lower().endswith(ext) for ext in EXTENSIONS[1:]):
                index.setdefault(fname, []).append(os.path.join(dirpath, fname))
    return index


def open_in_visual_studio(paths: list[str]) -> None:
    """Open *paths* in a running Visual Studio instance, else via devenv.exe."""
    try:
        import win32com.client  # type: ignore[import-not-found]

        dte = win32com.client.GetActiveObject("VisualStudio.DTE.17.0")
        for path in paths:
            dte.ItemOperations.OpenFile(path)
    except Exception:
        existing = [path for path in paths if os.path.exists(path)]
        if existing:
            subprocess.run(["devenv.exe", "/Edit", *existing], check=False)


def open_in_vscode(paths: list[str]) -> None:
    """Open *paths* in VS Code."""
    existing = [path for path in paths if os.path.exists(path)]
    if existing:
        subprocess.run([VSCODE_CMD, "-g", *existing], check=False)


def open_in_android_studio(paths: list[str]) -> None:
    """Open *paths* in Android Studio."""
    existing = [path for path in paths if os.path.exists(path)]
    if existing and os.path.isfile(ANDROID_STUDIO_CMD):
        subprocess.run([ANDROID_STUDIO_CMD, *existing], check=False)


class FileExplorerApp:
    """The tkinter application."""

    def __init__(self, root: tk.Tk) -> None:
        self.root = root
        self.file_map = load_index()
        self.suggestions: list[str] = []

        root.title("Multi-Ext File Opener")
        self._center_window(root)

        self.file_type_var = tk.StringVar(value=DEFAULT_EXTENSION)
        ttk.Combobox(
            root, textvariable=self.file_type_var, values=EXTENSIONS, state="readonly", width=6
        ).pack(pady=(15, 5))

        self.editor_var = tk.StringVar(value=EDITORS[0])
        ttk.Combobox(
            root, textvariable=self.editor_var, values=EDITORS, state="readonly", width=15
        ).pack(pady=(0, 10))

        self.entry_var = tk.StringVar()
        self.entry = tk.Entry(root, textvariable=self.entry_var)
        self.entry.pack(padx=20, fill="x")
        self.entry.bind("<Button-1>", self.on_click)
        self.entry.bind("<KeyRelease>", self.on_keyrelease)
        self.entry.bind("<Tab>", self.accept_autocomplete)
        self.entry.bind("<Return>", self.on_open)

        self.list_frame = tk.Frame(root)
        scroll = tk.Scrollbar(self.list_frame, orient=tk.VERTICAL)
        self.listbox = tk.Listbox(self.list_frame, yscrollcommand=scroll.set, height=20)
        scroll.config(command=self.listbox.yview)
        scroll.pack(side=tk.RIGHT, fill=tk.Y)
        self.listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.listbox.bind("<<ListboxSelect>>", self.on_listbox_select)

        self.status_var = tk.StringVar()
        tk.Label(root, textvariable=self.status_var, fg="green").pack(fill="x", pady=(0, 5), padx=20)

        tk.Button(root, text="Open File", command=self.on_open).pack(side=tk.BOTTOM, pady=15)

    @staticmethod
    def _center_window(window: tk.Tk, width: int = 400, height: int = 700) -> None:
        screen_w, screen_h = window.winfo_screenwidth(), window.winfo_screenheight()
        x, y = (screen_w - width) // 2, (screen_h - height) // 2
        window.geometry(f"{width}x{height}+{x}+{y}")

    def _names_for(self, extension: str) -> list[str]:
        return sorted(name for name in self.file_map if name.lower().endswith(extension))

    def _open_files(self, paths: list[str]) -> None:
        editor = self.editor_var.get()
        if editor == "Visual Studio":
            open_in_visual_studio(paths)
        elif editor == "VS Code":
            open_in_vscode(paths)
        elif editor == "Android Studio":
            open_in_android_studio(paths)

    def show_list(self, items: list[str]) -> None:
        self.listbox.delete(0, tk.END)
        for item in items:
            self.listbox.insert(tk.END, item)
        self.list_frame.pack(padx=20, fill="both", pady=(0, 5))

    def hide_list(self) -> None:
        self.list_frame.pack_forget()

    def on_click(self, _event: tk.Event) -> None:
        self.suggestions = self._names_for(self.file_type_var.get())
        self.show_list(self.suggestions)

    def on_keyrelease(self, _event: tk.Event) -> None:
        typed = self.entry_var.get().lower()
        all_names = self._names_for(self.file_type_var.get())
        prefix = [name for name in all_names if name.lower().startswith(typed)]
        contains = [name for name in all_names if typed in name.lower() and not name.lower().startswith(typed)]
        self.suggestions = prefix + contains
        if self.suggestions:
            self.show_list(self.suggestions)
        else:
            self.hide_list()

    def on_listbox_select(self, event: tk.Event) -> None:
        selection = event.widget.curselection()
        if not selection:
            return
        self.entry_var.set(event.widget.get(selection[0]))
        self.hide_list()
        self.entry.icursor(tk.END)
        self.entry.focus_set()

    def accept_autocomplete(self, _event: tk.Event) -> str:
        if self.suggestions:
            first = self.suggestions[0]
            self.entry_var.set(first)
            self.entry.icursor(len(first))
            self.hide_list()
        return "break"

    def on_open(self, _event: tk.Event | None = None) -> str:
        selection = self.entry_var.get()
        if selection not in self.file_map:
            messagebox.showwarning("Error", f"'{selection}' is not valid.")
            self.status_var.set(f"Error: '{selection}' not found")
            return "break"

        paths = [path for path in self.file_map[selection] if os.path.exists(path)]
        if not paths:
            messagebox.showerror("Not Found", f"No file on disk for '{selection}'.")
            self.status_var.set(f"No file for '{selection}'")
            return "break"

        self._open_files(paths)
        self.status_var.set(f"Opened {selection} in {self.editor_var.get()}")
        self.hide_list()
        return "break"


def main() -> int:
    root = tk.Tk()
    FileExplorerApp(root)
    root.mainloop()
    return 0


if __name__ == "__main__":
    sys.exit(main())
