import pandas as pd 
import matplotlib.pyplot as plt 
from cities import getCityDictionary

def getCurrentStatusPlot(numberOfMaxSelectedStates, year, states, filename):

	cases = pd.read_csv(filename, index_col="CITY")

	if(year != "ALL"):
		cases = cases.filter(like=year, axis=1)

	if(states is not None and len(states) > 0):
		cityDictionary = getCityDictionary()
		if("ALL" in states):
			numberOfMaxSelectedStates = len(cityDictionary)
		else:
			removals = []
			
			for cityKey in cityDictionary:
				if(cityKey not in states):
					removals.append(cityDictionary[cityKey])
			cases.drop(removals, axis=0, inplace=True)

	cases["Total"] = cases.sum(axis=1)

	# numberOfMaxSelectedStates = int(input("Enter max number of states to display: "))
	# numberOfMaxSelectedStates = 5

	cases.sort_values(["Total"], ascending=False, inplace=True)

	filteredCases = cases.head(numberOfMaxSelectedStates)

	print(filteredCases[["Total"]])

	return filteredCases.drop(["Total"], axis=1).T
	# filteredCases.drop(["Total"], axis=1).T.plot()
	# plt.show()