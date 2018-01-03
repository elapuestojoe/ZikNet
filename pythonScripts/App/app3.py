import tkinter as tk                    # imports
from tkinter import ttk
win = tk.Tk()                           # Create instance      
win.title("Python GUI")                 # Add a title 
tabControl = ttk.Notebook(win)          # Create Tab Control
tab1 = ttk.Frame(tabControl)   
tab2 = ttk.Frame(tabControl)	        # Create a tab 
tabControl.add(tab1, text='Tab 1')      # Add the tab
tabControl.add(tab2, text="Tab 2")
tabControl.pack(expand=1, fill="both")  # Pack to make visible
win.mainloop()                          # Start GUI