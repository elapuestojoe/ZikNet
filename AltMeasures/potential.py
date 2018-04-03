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

print("mosquitoesPerDay")
print(mosquitoesPerDay)

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

print(daysDiccionary)

days = []
pot = []
for key in mosquitoesPerDay:
	bites = 0
	if(key in daysDiccionary):
		bites = daysDiccionary[key]

	days.append(key)
	pot.append((bites / mosquitoesPerDay[key]) * (bites / 30) * (6.8535)) #TODO CHECAR EL 30  

plt.plot(days, pot, label="POTENTIAL")
plt.legend()
plt.show()

