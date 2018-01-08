import requests
import datetime

baseURL = "https://api.darksky.net/forecast"
key = "ffc914ba826e4727e4268cd35f46bb1c"

# Coordenadas extremas Veracruz
# Veracruz
extremeLatitudes = [17.0900, 22.2800]
extremeLongitudes = [-93.3600, -98.3900]

startLatitud = min(extremeLatitudes)
endLatitud = max(extremeLatitudes)
startLongitud = min(extremeLongitudes)
endLongitud = max(extremeLongitudes)

maxSteps = 900
currentSteps = 0

# def getCoordenatesList():
# 	coordenatesList = []
	
# 	# latitude = startLatitud

# 	# stepLatitude = (endLatitud - startLatitud) / 3
# 	# stepLongitude = (endLongitud - startLongitud) / 3

# 	# while(latitude <= endLatitud):
# 	# 	longitud = startLongitud
# 	# 	while(longitud <= endLongitud):
# 	# 		coordenatesList.append([latitude, longitud])
# 	# 		longitud = round(longitud+stepLongitude, 4)
# 	# 	latitude = round(latitude+stepLatitude, 4)

# 	# Centro
# 	coordenatesList.append([(endLatitud + startLatitud)/2, (endLongitud+startLongitud)/2])

# 	return coordenatesList

# coordenatesList = getCoordenatesList()

# coordenatesList = [[19.1737, -96.1342]] # Veracruz
coordenatesList = [[-12.97111,-38.51083]] #State of Bahia

dateStart = input("Enter first sunday of epidemiological year in DD-MM-YYYY format: ")
dateStartStringList = dateStart
dateStart = [int(i) for i in dateStart.split("-")]
dateStartAsDatetime = datetime.datetime(dateStart[2],dateStart[1],dateStart[0])

dateEnd = input("Enter last sunday of epidemiological year in DD-MM-YYYY format: ")
dateEndStringList = dateEnd
dateEnd = [int(i) for i in dateEnd.split("-")]
dateEndAsDatetime = datetime.datetime(dateEnd[2],dateEnd[1],dateEnd[0])

exclude = "currently,minutely,hourly"
units = "si"

fileName = "Bahia.csv"
searchesFile = open(fileName, "w")
searchesFile.write("coordinates,date,precipType,precipProbability,precipIntensity,precipIntensityMax,temperatureHigh,temperatureLow,humidity,pressure\n")

keys = ["precipType","precipProbability","precipIntensity","precipIntensityMax","temperatureHigh","temperatureLow","humidity","pressure"]

def writeToFile(coordenate, dateString, r):
	data = r.json()["daily"]["data"][0]
	searchesFile.write("{:.4f};{:.4f},".format(coordenate[0],coordenate[1]))
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

def getWeather(coordenate, date):
	
	dateString = "{:02}-{:02}-{:02}".format(date.year,date.month,date.day)
	extraParams = "exclude={}&units={}".format(exclude,units)
	print("{}/{}/{:.4f},{:.4f},{}T12:00:00?{}".format(baseURL, key, coordenate[0],coordenate[1], dateString, extraParams))
	r = requests.get("{}/{}/{:.4f},{:.4f},{}T12:00:00?{}".format(baseURL, key, coordenate[0],coordenate[1], dateString, extraParams))
	if(r.status_code == 200):
		writeToFile(coordenate, dateString, r)
	else:
		print("Error")

# Divide by weeks
currentDay = dateStartAsDatetime
weekNumber = 1

# Request confirmation before attempting to retrieve data
print("Current Configuration: ")
print("Date Start {}".format(dateStartAsDatetime))
print("Date End {}".format(dateEndAsDatetime))
print("Number of steps {}".format(maxSteps))
print("Filename: {}".format(fileName))
print("coordenatesList: {}".format(coordenatesList))
continueInput = input("Continue? (Y/N) ")

if(continueInput == "Y" or continueInput == "y"):

	while(currentDay <= dateEndAsDatetime and currentSteps+len(coordenatesList)<= maxSteps):
	# while(currentDay <= dateEndAsDatetime and currentSteps+(7*len(coordenatesList)) <= maxSteps):
		for coordenate in coordenatesList:
			getWeather(coordenate, currentDay)

		currentDay = currentDay+datetime.timedelta(days=1)
		currentSteps += len(coordenatesList)

else:
	print("Canceled by user input")