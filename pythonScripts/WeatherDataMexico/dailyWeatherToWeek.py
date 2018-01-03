
filename = input("Enter filename: ")

header = None
startDate = None
day = 0
coordinates = None

dictData = {"precipProbability": [],
			"precipIntensity": [],
			"temperatureHigh": [],
			"temperatureLow": [],
			"humidity": [],
			"pressure": []}

output = open("BahiaWeatherData.csv", "w")
output.write("coordinates,date,precipProbability,precipIntensity,avgTemp,humidity,pressure\n")

for line in open(filename, "r"):
	if(header is None):
		header = line.split(",")
	else:
		data = line.split(",")
		
		# convert to int:
		for i in range(3,10):
			if(data[i] != "NA" and data[i] != "NA\n"):
				data[i] = float(data[i])

		if(coordinates is None):
			coordinates = data[0]

		if(startDate is None):
			startDate = data[1]

		dictData["precipProbability"].append(data[3])
		dictData["precipIntensity"].append(data[4])
		dictData["temperatureHigh"].append(data[6])
		dictData["temperatureLow"].append(data[7])
		dictData["humidity"].append(data[8])
		dictData["pressure"].append(data[9])
		if(day < 6):
			day+=1
		else:


			for key in dictData:
				dictData[key] = list(filter(("NA").__ne__, dictData[key]))
				dictData[key] = list(filter(("NA\n").__ne__, dictData[key]))

			output.write("{},".format(coordinates))
			output.write("{},".format(startDate))

			if(len(dictData["precipProbability"]) == 0):
				output.write("{},".format("NA"))
			else:
				output.write("{},".format(sum(dictData["precipProbability"])/len(dictData["precipProbability"])))

			if(len(dictData["precipIntensity"]) == 0):
				output.write("{},".format("NA"))
			else:
				output.write("{},".format(sum(dictData["precipIntensity"])/len(dictData["precipIntensity"])))

			temperatureHigh = sum(dictData["temperatureHigh"])/len(dictData["temperatureHigh"])
			temperatureLow = sum(dictData["temperatureLow"])/len(dictData["temperatureLow"])

			output.write("{},".format((temperatureHigh+temperatureLow)/2))
			output.write("{},".format(sum(dictData["humidity"])/len(dictData["humidity"])))

			print(dictData["pressure"])
			if(len(dictData["pressure"]) == 0):
				output.write("{}\n".format("NA"))
			else:
				output.write("{}\n".format(sum(dictData["pressure"])/len(dictData["pressure"])))

			# print("AVG")
			# print("Week {} - {}".format(startDate, data[1]))
			# for key in dictData:
			# 	dictData[key] = list(filter(("NA").__ne__, dictData[key]))
			# 	print("{} : {}".format(key, sum(dictData[key])/len(dictData[key])))
			# # 

			dictData = {"precipProbability": [],
						"precipIntensity": [],
						"temperatureHigh": [],
						"temperatureLow": [],
						"humidity": [],
						"pressure": []}


			startDate = None
			day = 0
		