import tkinter as tk
from tkinter import messagebox
import math

BG_COLOR = "#22223b"
FG_COLOR = "#f2e9e4"
BTN_BG = "#4a4e69"
BTN_FG = "#f2e9e4"
BTN_ACTIVE_BG = "#9a8c98"
ENTRY_BG = "#c9ada7"
ENTRY_FG = "#22223b"
FONT = ("Segoe UI", 12)
BTN_FONT = ("Segoe UI", 11, "bold")

X_MIN, X_MAX = -10, 10
Y_MIN, Y_MAX = -10, 10

canvas: tk.Canvas | None = None
entry_func: tk.Entry | None = None

def to_screen(x, y, width, height):
    sx = (x - X_MIN) / (X_MAX - X_MIN) * width
    sy = height - (y - Y_MIN) / (Y_MAX - Y_MIN) * height
    return sx, sy

def draw_axes():
    global canvas
    assert canvas is not None, "canvas has not been created yet"
    w = int(canvas['width'])
    h = int(canvas['height'])
    if Y_MIN < 0 < Y_MAX:
        _, sy = to_screen(0, 0, w, h)
        canvas.create_line(0, sy, w, sy, fill=FG_COLOR)
    if X_MIN < 0 < X_MAX:
        sx, _ = to_screen(0, 0, w, h)
        canvas.create_line(sx, 0, sx, h, fill=FG_COLOR)

def plot_function():
    global canvas, entry_func
    assert entry_func is not None, "entry_func has not been created yet"
    assert canvas is not None, "canvas has not been created yet"
    expr = entry_func.get().strip()
    if expr == "":
        messagebox.showerror("Invalid input", "Please enter a function to plot.")
        return
    allowed = {"math": math, "x": 0}
    for name in ["sin", "cos", "tan", "exp", "log", "sqrt", "fabs"]:
        allowed[name] = getattr(math, name)
    points = []
    w = int(canvas['width'])
    h = int(canvas['height'])
    step = (X_MAX - X_MIN) / w
    try:
        x = X_MIN
        while x <= X_MAX:
            allowed['x'] = x
            y = eval(expr, {"__builtins__": {}}, allowed)
            if isinstance(y, (int, float)) and not (math.isinf(y) or math.isnan(y)):
                sx, sy = to_screen(x, y, w, h)
                points.append((sx, sy))
            x += step
    except Exception as e:
        messagebox.showerror("Error", f"Invalid function:\n{e}")
        return
    canvas.delete("plot")
    if points:
        for i in range(1, len(points)):
            x0, y0 = points[i - 1]
            x1, y1 = points[i]
            canvas.create_line(x0, y0, x1, y1, fill=BTN_FG, tags="plot")

def clear_plot():
    global canvas, entry_func
    assert entry_func is not None, "entry_func has not been created yet"
    assert canvas is not None, "canvas has not been created yet"
    entry_func.delete(0, tk.END)
    canvas.delete("all")
    draw_axes()

root = tk.Tk()
root.title("Function Grapher")
root.geometry("600x500")
root.configure(bg=BG_COLOR)

label_func = tk.Label(root, text="Enter function of x:", bg=BG_COLOR, fg=FG_COLOR, font=FONT)
label_func.pack(pady=(10, 5))
entry_func = tk.Entry(root, bg=ENTRY_BG, fg=ENTRY_FG, font=FONT, relief=tk.FLAT)
entry_func.pack(pady=5, fill="x", padx=20)

frame_buttons = tk.Frame(root, bg=BG_COLOR)
frame_buttons.pack(pady=10)

btn_plot = tk.Button(
    frame_buttons,
    text="Plot",
    width=10,
    font=BTN_FONT,
    bg=BTN_BG,
    fg=BTN_FG,
    activebackground=BTN_ACTIVE_BG,
    command=plot_function,
)
btn_plot.grid(row=0, column=0, padx=5)

btn_clear = tk.Button(
    frame_buttons,
    text="Clear",
    width=10,
    font=BTN_FONT,
    bg=BTN_BG,
    fg=BTN_FG,
    activebackground=BTN_ACTIVE_BG,
    command=clear_plot,
)
btn_clear.grid(row=0, column=1, padx=5)

canvas = tk.Canvas(root, width=580, height=360, bg=BG_COLOR, highlightthickness=0)
canvas.pack(fill="both", expand=True, padx=10, pady=10)
draw_axes()

root.mainloop()
