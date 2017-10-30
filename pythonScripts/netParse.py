import sys
import xml.etree.ElementTree
import json

# graph
import networkx as nx
import matplotlib.pyplot as plt
def parseContacts():

	def getContacts(contactList):
		contactList = contactList.replace("[", "")
		contactList = contactList.replace("]", "")
		contactList = contactList.replace("{", "")
		contactList = contactList.replace("}", "")
		
		dictionary = {}
		for contact in contactList.split(" "):
			dictionary[contact] = set()

		return dictionary

	filename = "CatemacoBaseline_HET 41898.xml"
	if(len(sys.argv) == 2):
		filename = sys.argv[2] 
	else:
		print("ERROR, taking default file")

	e = xml.etree.ElementTree.parse(filename).getroot()
	# e = xml.etree.ElementTree.parse('CatemacoFogging_HET 24959.xml').getroot()
	# e = xml.etree.ElementTree.parse("Validation.xml")
	# e = xml.etree.ElementTree.parse('CatemacoOxitec_HET 26749.xml').getroot()
	# e = xml.etree.ElementTree.parse('CatemacoWolbachia_HET 1238.xml').getroot()


	final_outputs = e.find('final_outputs')

	biteList = None
	contactList = None
	for child in final_outputs:

		if(child.attrib["id"]=="biteList"):
			biteList = child.text
		elif(child.attrib["id"]=="contactList"):
			contactList = child.text

	contactDictionary = getContacts(contactList)

	brackets = 0;
	curlys = 0;
	bite = 0;
	openC = False

	f = ""
	for char in biteList:
		if(char == "["):
			brackets += 1

			if(brackets == 1):
				print("OPEN")
			if(brackets == 2):
				openC = True
		elif(char == "{"):
			curlys += 1

		elif(char == "]"):
			brackets -= 1

			if(brackets == 0):
				print("CLOSE")
			elif(brackets == 1):
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
	for line in f.split("\n"):
		arr = line.split(",")
		bites = []
		times = []
		# Problemas con coma final
		arr.pop()

		# Eliminar cuando solo existe un piquete
		if(len(arr) > 3):
			for i in range(1,len(arr)-1,2):
				bites.append(arr[i])
				times.append(arr[i+1])
				
				if(arr[i+1] not in timeList):
					timeList[arr[i+1]] = [arr[0]]
				else:
					timeList[arr[i+1]].append(arr[0])

			biteList[arr[0]] = {"bites":bites,"times":times}

	# Para manejar las cosas más fácilmente tendremos un diccionario de mosquitos/piquetes
	 # y un diccionario con los tiempos/mosquito
	# Parse contactList:
	curlys = 0
	buff = ""
	contList = []
	for char in contactList:
		if char == "{":
			curlys +=1
		elif char == "}":
			curlys -=1

			if curlys == 0 and buff != "":
				contList.append(buff)
				buff = ""

		elif char != "[" and char != "]" and char != " ":
			buff += char

	return contList, biteList, timeList

if __name__ == '__main__':
	parseContacts()