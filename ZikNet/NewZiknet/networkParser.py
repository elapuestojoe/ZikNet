import sys
import xml.etree.ElementTree

def parseContacts(filename):
	e = xml.etree.ElementTree.parse(filename).getroot()
	final_outputs = e.find('final_outputs')

	biteList = None
	# contactList = None
	for child in final_outputs:
		# print(child.attrib)
		if(child.attrib["id"]=="biteList"):
			biteList = child.text
		# elif(child.attrib["id"]=="contactList"):
		# 	contactList = child.text

	brackets = 0;
	curlys = 0;
	bite = 0;
	openC = False

	f = ""
	for char in biteList:
		if(char == "["):
			brackets += 1
			if(brackets == 2):
				openC = True
		elif(char == "{"):
			curlys += 1

		elif(char == "]"):
			brackets -= 1
			if(brackets == 1):
				openC = False
				f += "\n"

		elif(char == "}"):
			curlys -= 1
			if(openC):
				f+=","
		elif(char!= "\n" and char != " " and char != "\t"):
			f+=char

	# f = Bitelist
	# Parse biteList
	biteList = {}
	timeList = {}
	contactList = set()
	# Para este punto el archivo tiene la siguiente forma:
	# 439,as,4301,an,7062,ax,8938, \n
	# Donde 439 es el id del mosquito y lo siguiente son pares humano-tiempo de piquete
	for line in f.split("\n"):
		arr = line.split(",")
		bites = []
		times = []
		# Problemas con coma final
		arr.pop()

		# Eliminar cuando solo existe un piquete
		if(len(arr) >= 3):
			for i in range(1,len(arr)-1,2):

				bites.append(arr[i])
				times.append(int(arr[i+1]))

				contactList.add(arr[i]) #Agrega la persona picada a un set para tener un arreglo de personas

				if(arr[i+1] not in timeList):
					timeList[int(arr[i+1])] = [arr[0]]
				else:
					timeList[int(arr[i+1])].append(arr[0])

			biteList[arr[0]] = {"bites":bites,"times":times}

	
	#Contactlist es cada humano del experimento
	#Bitelist es un diccionario {mosquitid: {tiempos: [], piquetes: []}}
	#Timelist es un diccionario {tiempos : [idMosquitoConPiquete]}
	return contactList, biteList, timeList

if __name__ == '__main__':
	parseContacts("10-0/CatemacoBaseline_HET 123813.xml")