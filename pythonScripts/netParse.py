import sys
import xml.etree.ElementTree
import json

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
if(len(sys.argv) < 2):
	filename = sys.argv[2] 
else:
	print("ERROR, taking default file")

e = xml.etree.ElementTree.parse(filename).getroot()
# e = xml.etree.ElementTree.parse('CatemacoFogging_HET 24959.xml').getroot()
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

file = open("out.txt", "w")
file.write(f)
file.close()

f = open("out.txt", "r")
lineWrite = ""
for line in f.readlines():
	lineP = line.split(",")
	if(len(lineP) > 4):
		for i in range(1, len(lineP), 2):
			lineWrite += (lineP[i])
			if(i < len(lineP) - 3):
				lineWrite += ","

file = open("parsed.txt", "w")
file.write(lineWrite)
f.close()
file.close()

# Step 3: Convert parsed.txt
file = open("parsed.txt", "r")

for line in file.readlines():
	bites = line.split(",")

	for i in range(1, len(bites)):
		origin = bites[i-1]
		destination = bites[i].replace("\n", "")

		if(origin != destination):
			contactDictionary[origin].add(destination)

# By this time contact dictionary will have a collection of sets that represent bites

output = ""
for key in contactDictionary:
	origin = key
	bites = contactDictionary[key]

	for bite in bites:
		output += "{0},{1}\n".format(origin, bite)

f = open("final.txt", "w")
f.write(output)
f.close()
file.close()