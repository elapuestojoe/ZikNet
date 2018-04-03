from parserFile import ParseTicks
from networkParser import parseContacts
import matplotlib.pyplot as plt
import random

TICKS_PER_DAY = 288
ticksDiccionary = ParseTicks("./DATA/10-0/CatemacoBaseline_HET 257082.xml")

# print(ticksDiccionary[3024])
daysDiccionary = {}
maxDay = 0
for key in sorted(ticksDiccionary.keys()):
	day = key//TICKS_PER_DAY
	if(day not in daysDiccionary):
		daysDiccionary[day] = {"total": ticksDiccionary[key]["FemalePopulation"], "entries": 1}
		if(day > maxDay):
			maxDay = day
	else:
		daysDiccionary[day]["total"] += ticksDiccionary[key]["FemalePopulation"]
		daysDiccionary[day]["entries"] += 1

mosquitoesPerDay = {}

for key in daysDiccionary:
	mosquitoesPerDay[key] = daysDiccionary[key]["total"] / daysDiccionary[key]["entries"]

# print("mosquitoesPerDay")
# print(mosquitoesPerDay)

print("bitesPerDay")
contList, biteList, timeList = parseContacts("./DATA/10-0/CatemacoBaseline_HET 257082.xml")

daysDiccionary = {}
for key in biteList:
	for time in biteList[key]["times"]:
		day = int(time)//TICKS_PER_DAY
		if(day not in daysDiccionary):
			daysDiccionary[day] = 1
		else:
			daysDiccionary[day] +=1

days = []
bites = []
for key in daysDiccionary:
	days.append(key)
	bites.append(daysDiccionary[key]*0.425)

plt.plot(days, bites, label="EIR")
plt.legend()
plt.show()

