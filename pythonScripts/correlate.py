from numpy import genfromtxt
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

A = pd.read_csv("2016Cases.csv", sep=",", encoding="latin-1") 
B = pd.read_csv("2016SearchesN.csv", sep=",", encoding="latin-1")


del A["2016-01-02"]
del A["CITY"]
del B["CITY"]
aRows = []
for index, row in A.iterrows():
	aRows.append(row.tolist())

bRows = []
for index,row in B.iterrows():
	bRows.append(row.tolist())

fits = []
fitsfns = []
for i in range(len(aRows)):
	fit = np.polyfit(aRows[i], bRows[i],1)
	fitsfns.append(np.poly1d(fit))
	fits.append(fit)
	# print(np.corrcoef(aRows[i], bRows[i]))

plt.plot(aRows[0], bRows[0], "yo", aRows[0], fitsfns[0], "--k")
# aSol = []*len(aRows)
# bSol = []*len(bRows)
# for i in range(len(aRows)):

# for i in range(len(aRows)):
# 	# print(np.correlate(aRows[i][1], bRows[i][1]))
# 	print(aRows[i])
# 	# print(len(bRows[i][1]))