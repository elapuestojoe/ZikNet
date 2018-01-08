import json

searchesFile = open("Veracruz2.csv", "w")
searchesFile.write("coordenates,date,precipType,precipProbability,precipIntensity,precipIntensityMax,temperatureHigh,temperatureLow,humidity,pressure\n")

keys = ["precipType","precipProbability","precipIntensity","precipIntensityMax","temperatureHigh","temperatureLow","humidity","pressure"]

def writeToFile(coordenate, dateString, r):
	data = r["daily"]["data"][0]
	searchesFile.write("{:.4f}-{:.4f},".format(coordenate[0],coordenate[1]))
	searchesFile.write("{},".format(dateString))

	for i in range(len(keys)):
		key = keys[i]
		if(key in data):
			searchesFile.write(str(data[key]))
		else:
			searchesFile.write("NA")
		if i < len(keys)-1:
			searchesFile.write(",")
	searchesFile.write("\n")

r = json.load(open('test.json'))
coordenate = [27.0000,28.0000]
dateString = "2016-01-02"
writeToFile(coordenate, dateString, r)