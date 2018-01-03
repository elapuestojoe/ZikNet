import pandas as pd
from temp_rainParser import ParseFile
CityDictionary = {
	"Aguascalientes" : "Mexico-Aguascalientes",
	"Baja California" : "Mexico-Baja_California",
	"Baja California Sur" : "Mexico-Baja_California_Sur",
	"Campeche" : "Mexico-Campeche",
	"Chiapas" : "Mexico-Chiapas",
	"Chihuahua" : "Mexico-Chihuahua",
	"Coahuila" : "Mexico-Coahuila_de_Zaragoza",
	"Colima" : "Mexico-Colima",
	"Durango" : "Mexico-Durango",
	"Guanajuato" : "Mexico-Guanajuato",
	"Guerrero" : "Mexico-Guerrero",
	"Hidalgo" : "Mexico-Hidalgo",
	"Jalisco" : "Mexico-Jalisco",
	"Mexico City" : "Mexico-Mexico_City",
	"Michoacán" : "Mexico-Michoacan_de_Ocampo",
	"Morelos" : "Mexico-Morelos",
	"Nayarit" : "Mexico-Nayarit",
	"Nuevo Leon" : "Mexico-Nuevo_Leon",
	"Oaxaca" : "Mexico-Oaxaca",
	"Puebla" : "Mexico-Puebla",
	"Querétaro" : "Mexico-Queretaro_de_Arteaga",
	"Quintana Roo" : "Mexico-Quintana_Roo",
	"San Luis Potosi" : "Mexico-San_Luis_Potosi",
	"Sinaloa" : "Mexico-Sinaloa",
	"Sonora" : "Mexico-Sonora",
	"State of Mexico" : "Mexico-State_Of_Mexico",
	"Tabasco" : "Mexico-Tabasco",
	"Tamaulipas" : "Mexico-Tamaulipas",
	"Tlaxcala" : "Mexico-Tlaxcala",
	"Veracruz" : "Mexico-Veracruz_de_Ignacio_de_la_Llave",
	"Yucatan" : "Mexico-Yucatan",
	"Zacatecas" : "Mexico-Zacatecas"
}

# Leer csv Temp
# tempCSV = pd.read_csv("TempPromedio2016.csv")
# searchesCSV = pd.read_csv("2016SearchesN.csv")


# def select(entidad, mes):
# 	# print(tempCSV[["Entidad", mes]])
# 	print(tempCSV[["Entidad", mes]].loc[tempCSV["Entidad"]==entidad][mes])

# select("Mexico-Zacatecas", "Febrero")

# def parseSearches():
# 	for index, row in searchesCSV.iterrows():
# 		print(row)
# 		# for ind, column in enumerate(row):
# 		# 	print(ind)

# parseSearches()

rain = ParseFile("PrecipitacionMexico.csv")
temp = ParseFile("TempMexico.csv")
cases = ParseFile("MexicoCases.csv")
searches = ParseFile("MexicoSearches.csv")

model = open("modelComplete.csv", "w")
model.write("City,Searches,Rain,Temp,Cases\n")

for city in cases.keys():
	dictTimeCases = cases[city]
	for time in dictTimeCases:
		numberCases = dictTimeCases[time]
		if(city in searches and time in searches[city]):
			numberSearches = searches[city][time]
		# get temp/rain
		timeFormatted = time.split("/")
		timeFormatted = "{}/{}".format(int(timeFormatted[1]),timeFormatted[2])
		if(city in temp and timeFormatted in temp[city]):
			currentTemp = temp[city][timeFormatted]
		if(city in rain and timeFormatted in rain[city]):
			currentRain = rain[city][timeFormatted]
		entry = "{},{},{},{},{}\n".format(city,numberSearches,currentRain,currentTemp,numberCases)
		model.write(entry)

model.close()
# def getMonth(date):
# 	return int(date.split("/")[1])

# def getHeight():
# 	height = {}
# 	heightFile = open("AlturaMexico.csv")
# 	for line in heightFile:
# 		nLine = line.strip().split(",")
# 		if(nLine[0]!="Entidad"):
# 			height[nLine[0]] = nLine[1]
# 	return height
# height = getHeight()

# searches = open("2017Searches.csv", "r")
# model = open("model2017.csv", "w")
# model.write("Entidad,Fecha,Altura,Busquedas,Precipitacion,Temp,Casos\n")
# for line in searches:
# 	pLine = line.strip().split(",")
# 	if(pLine[0]=="CITY"):
# 		times = pLine
# 	else:
# 		for i in range(1, len(pLine)-2): #-2 para evitar un crash en 2017
# 			model.write(pLine[0]+",")
# 			model.write(times[i]+",")
# 			model.write(height[pLine[0]]+",")
# 			model.write(pLine[i]+",")
# 			model.write(precipitacion[pLine[0]][getMonth(times[i])-1]+",")
# 			model.write(temp[pLine[0]][getMonth(times[i])-1]+",")
# 			model.write(cases[pLine[0]][i])
# 			model.write("\n")
# searches.close()
# model.close()
