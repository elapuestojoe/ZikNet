from tkinter import *
# the constructor syntax is:
# OptionMenu(master, variable, *values)

OPTIONS = [
    "Veracruz",
]

class App:
	def __init__(self, master):
		frame = tkinter.Frame(master)

		statesList = StringVar(master)
		statesList.set(OPTIONS[0])
		statesMenu = (OptionMenu(*(master,statesList) + tuple(OPTIONS)))

master = Tk()

variable = StringVar(master)
variable.set(OPTIONS[0]) # default value

w = OptionMenu(*(master,variable) + tuple(OPTIONS))
w.pack()

mainloop()