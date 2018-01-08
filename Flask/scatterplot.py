import matplotlib.pyplot as plt 
import pandas as pd

from cities import getCityDictionary

cityDictionary = getCityDictionary()

def getScatterPlot(year, state):
	modelFilename = "data/modelMexico-2015-2017.csv"
	model = pd.read_csv(modelFilename, index_col="CITY")

	if(year != "ALL"):
		model = model[model["Date"].str.contains(year)]

	if(state != "None"):
		model = model.loc[cityDictionary[state]]
	else:
		model = model.loc["Mexico-Veracruz_de_Ignacio_de_la_Llave"]

	print(model)
	model.drop(["Date", "Population", "cases/100K"], axis=1, inplace=True)
	return model

if __name__ == "__main__":
	getScatterPlot("2015", [])