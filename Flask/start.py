from flask import Flask, render_template, redirect, flash
from visualizer import getCurrentStatusPlot
from forms import VisualizerForm, ScatterForm
from config import Config
from scatterplot import getScatterPlot

app = Flask(__name__)
app.config.from_object(Config)

@app.route("/")
def hello():
	return "Hello World!"

@app.route("/index")
def index():
	user = {"username":"Kevin"}
	return render_template("index.html", title="Home", user=user)


def basicPlotter(filename):
	import matplotlib.pyplot as plt
	from io import BytesIO
	import base64

	#Set up Form
	form = VisualizerForm()

	#Check if POST
	numberOfStates = (form.numberOfStates.data and int(form.numberOfStates.data)) or 5
	year = (form.year.data and str(form.year.data)) or "ALL"
	states = form.statesCheckbox.data

	#Getting plot
	currentStatusPlot = getCurrentStatusPlot(numberOfStates, year, states, filename)
	currentStatusPlot.plot()

	### Saving plot to disk in png format
	# plt.savefig('img/test_plot.png')

	### Rendering Plot in Html
	figfile = BytesIO()
	plt.savefig(figfile, format='png')
	figfile.seek(0)
	figdata_png = base64.b64encode(figfile.getvalue())
	result = figdata_png
	### Remove b' from begining and ' in the end
	### So that we can send the string within base64 noation
	result = str(figdata_png)[2:-1]
	return render_template('output.html',
		result=result, 
		form=form)

@app.route("/cases", methods=["GET", "POST"])
def cases():
	return basicPlotter("data/MexicoCases2015-2017.csv")

@app.route("/searches", methods=["GET", "POST"])
def searches():
	return basicPlotter("data/MexicoSearches2015-2017.csv")

@app.route("/scatterplot", methods=["GET", "POST"])
def scatterplot():
	import matplotlib.pyplot as plt
	from io import BytesIO
	import base64
	from pandas.plotting import scatter_matrix
	#Set up Form
	form = ScatterForm()

	#Check if POST
	year = (form.year.data and str(form.year.data)) or "ALL"
	state = form.statesCheckbox.data
	#Getting plot
	scatterplot = getScatterPlot(year, state)
	scatter_matrix(scatterplot)

	### Saving plot to disk in png format
	# plt.savefig('img/test_plot.png')

	### Rendering Plot in Html
	figfile = BytesIO()
	plt.savefig(figfile, format='png')
	figfile.seek(0)
	figdata_png = base64.b64encode(figfile.getvalue())
	result = figdata_png
	### Remove b' from begining and ' in the end
	### So that we can send the string within base64 noation
	result = str(figdata_png)[2:-1]
	return render_template('scatter.html',
		result=result, 
		form=form)

if __name__ == "__main__":
	app.run()
