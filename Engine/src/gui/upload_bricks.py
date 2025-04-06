import tkinter as tk
from tkinter import filedialog, messagebox
import shutil
import os

def upload_bricks():
    # Initialize Tkinter
    root = tk.Tk()
    root.withdraw()  # Hide the root window

    # Open file dialog to select the new bricks.json
    file_path = filedialog.askopenfilename(
        title="Select a bricks.json file",
        filetypes=[("JSON Files", "*.json")]
    )

    if not file_path:
        messagebox.showinfo("Upload Cancelled", "No file selected.")
        return

    # Destination path for the new bricks.json
    dest_path = os.path.join(os.getcwd(), "bricks.json")

    try:
        # Replace the old bricks.json with the new one
        shutil.copy(file_path, dest_path)
        messagebox.showinfo("Success", f"bricks.json replaced successfully!")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to replace bricks.json: {e}")

if __name__ == "__main__":
    upload_bricks()
