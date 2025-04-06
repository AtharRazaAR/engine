import tkinter as tk
from tkinter import messagebox, simpledialog
import json

class BrickEditor:
    def __init__(self, root):
        self.root = root
        self.root.title("Brick Editor")

        self.canvas_width = 800
        self.canvas_height = 600
        self.brick_width = 50
        self.brick_height = 20
        self.bricks = []

        self.color_mapping = {
            1: "blue",
            2: "red",
            3: "green"
        }

        self.canvas = tk.Canvas(self.root, width=self.canvas_width, height=self.canvas_height, bg="white")
        self.canvas.pack()

        self.button_frame = tk.Frame(self.root)
        self.button_frame.pack()

        self.save_button = tk.Button(self.button_frame, text="Save to JSON", command=self.save_to_json)
        self.save_button.pack(side=tk.LEFT)

        self.clear_button = tk.Button(self.button_frame, text="Clear Screen", command=self.clear_screen)
        self.clear_button.pack(side=tk.LEFT)

        self.canvas.bind("<Button-1>", self.add_brick)

    def add_brick(self, event):
        x = event.x
        y = event.y

        # Align the brick to the grid
        x_start = (x // self.brick_width) * self.brick_width
        y_start = (y // self.brick_height) * self.brick_height

        # Check if a brick already exists in this position
        for brick in self.bricks:
            if brick['x'] == x_start and brick['y'] == y_start:
                messagebox.showerror("Error", "Cannot place a brick on top of another brick!")
                return

        # Ask for brick strength
        strength = simpledialog.askinteger("Brick Strength", "Enter brick strength (1-3):", minvalue=1, maxvalue=3)
        if strength is None:
            return

        # Map strength to color
        color = self.color_mapping.get(strength, "blue")  # Default to blue if strength is invalid

        # Draw the brick and add to the list
        self.canvas.create_rectangle(x_start, y_start, x_start + self.brick_width, y_start + self.brick_height, fill=color)
        self.bricks.append({"x": x_start, "y": y_start, "color": color, "strength": strength})

    def save_to_json(self):
        filename = "bricks.json"
        with open(filename, 'w') as f:
            json.dump(self.bricks, f, indent=4)
        messagebox.showinfo("Saved", f"Bricks saved to {filename}")

    def clear_screen(self):
        self.canvas.delete("all")
        self.bricks.clear()

if __name__ == "__main__":
    root = tk.Tk()
    app = BrickEditor(root)
    root.mainloop()
