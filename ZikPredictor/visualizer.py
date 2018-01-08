import pandas as pd 
import matplotlib.pyplot as plt 

casesFilename = input("Enter name of cases file: ")
searchesFilename = input("Enter name of searches file: ")

year = input("Enter desired year or ALL: ")

cases = pd.read_csv(casesFilename, index_col="CITY")

if(year != "ALL"):
	cases = cases.filter(like=year, axis=1)

cases["Total"] = cases.sum(axis=1)

numberOfMaxSelectedStates = int(input("Enter max number of states to display: "))

cases.sort_values(["Total"], ascending=False, inplace=True)

filteredCases = cases.head(numberOfMaxSelectedStates)

print(filteredCases[["Total"]])

filteredCases.drop(["Total"], axis=1).T.plot()
plt.show()

