import tkinter as tk

def on_button_click():
    label.config(text="Button clicked!")

app = tk.Tk()
app.title("Simple GUI")

label = tk.Label(app, text="Hello, Tkinter!")
label.pack()

button = tk.Button(app, text="Click Me", command=on_button_click)
button.pack()

app.mainloop()
