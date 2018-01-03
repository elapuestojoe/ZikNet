import tkinter

from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
from math import cos,sin

class App:
	def __init__(self, master):

		#Contenedor
		frame = tkinter.Frame(master)

		#Dos Botones
		self.button_left = tkinter.Button(frame,text="< Decrease Slope",
			command=self.decrease)
		self.button_left.pack(side="left")

		self.button_right = tkinter.Button(frame, text="Increase Slope >",
			command=self.increase)
		self.button_right.pack(side="left")

		self.button_three = tkinter.Button(frame,text="Button",command=None)
		self.button_three.pack(side="left")
		
		fig = Figure()
		ax = fig.add_subplot(111)
		self.line, = ax.plot(range(10))

		self.canvas = FigureCanvasTkAgg(fig,master=master)
		self.canvas.show()
		self.canvas.get_tk_widget().pack(side='top', fill='both', expand=1)
		frame.pack()

	def decrease(self):
		x, y = self.line.get_data()
		self.line.set_ydata(y - 0.2 * x )
		self.canvas.draw()

	def increase(self):
		x, y = self.line.get_data()
		self.line.set_ydata(y + 0.2 * x)
		self.canvas.draw()

root = tkinter.Tk()
app = App(root)
root.mainloop()