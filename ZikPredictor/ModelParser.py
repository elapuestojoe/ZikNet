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

rain = ParseFile("data/MexicoPrecipitation2015-2017.csv")
temp = ParseFile("data/MexicoTemperature2015-2017.csv")
cases = ParseFile("data/MexicoCases2015-2017.csv")
searches = ParseFile("data/MexicoSearches2015-2017.csv")

populationFile = open("data/MexicoPopulation.csv")
population = {}
for line in populationFile:
	line = line.strip().split(",")
	population[line[0]] = "".join(line[1:]).strip("\"")

model = open("modelMexico2-2015-2017.csv", "w")
model.write("City,Date,Searches,Rain,Temp,Cases,Population,cases/100K\n")

def sorting(date):
	splitup = date.split("/")
	return splitup[2], splitup[1], splitup[0]

for city in cases.keys():
	dictTimeCases = cases[city]

	cityPopulation = population[city]
	for time in sorted(dictTimeCases.keys(), key=sorting):

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

		casesPer100K = 100000.0 * int(numberCases) / int(cityPopulation)
		entry = "{},{},{},{},{},{},{},{}\n".format(city,time,numberSearches,currentRain,currentTemp,numberCases,cityPopulation,casesPer100K)
		model.write(entry)

model.close()