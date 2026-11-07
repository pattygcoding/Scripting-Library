#!/usr/bin/env python3
"""A minimal tkinter GUI with a label and a button."""

from __future__ import annotations

import sys
import tkinter as tk


def main() -> int:
    root = tk.Tk()
    root.title("Simple GUI")

    label = tk.Label(root, text="Hello, Tkinter!")
    label.pack()

    def on_click() -> None:
        label.config(text="Button clicked!")

    tk.Button(root, text="Click Me", command=on_click).pack()

    root.mainloop()
    return 0


if __name__ == "__main__":
    sys.exit(main())
