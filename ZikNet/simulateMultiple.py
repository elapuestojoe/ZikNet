import os
from networkParser import parseContacts
import random

# Inv alternativa Estimated Incubation Period for Zika Virus Disease 

initialInfectedNumber = 3
simulationsPerFile = 10

def initFile(filename):
	outputFile = open("generated_data/{}.csv".format(filename), "w")
	outputFile.write("originalFile,r0\n")
	return outputFile

def simulateEpidemic(contactList, biteList, timeList):
	infectionsPerContact = {}
	for i in contactList:
		infectionsPerContact[i] = []
	# Lo interesante, modelar la epidemia
	timeListSortedKeys = sorted(timeList.keys())
	exposed = {}

	# Diccionario SEIR para plots
	SEIR = {}

	contactList = sorted(contactList)
	# print("contactList: {}".format(contactList))
	randomInfected = random.sample(contactList, initialInfectedNumber)
	initialTime = 0 if len(timeListSortedKeys) == 0 else int(timeListSortedKeys[0])
	infectedPeople = {}
	susceptible = contactList.copy()
	for i in randomInfected:
		infectedPeople[i] = initialTime
		susceptible.remove(i)
	recovered = {}
	asymptomatic = {}
	infectedMosquitoes = []
	mosquitoesContact = {}
	edges = []

	fourDays = 1152

	for key in timeListSortedKeys:
		currentMosquitoes = timeList[key]
		currTime = int(key)
		for mosquito in currentMosquitoes:
			# Get time/bite
			currentBiteList = biteList[mosquito]
			i = currentBiteList["times"].index(key)
			bited = currentBiteList["bites"][i]
			
			if(bited in infectedPeople and mosquito not in infectedMosquitoes):
				# pVH Transmission probability from an infectious human to a susceptible mosquito per bite    0.3–0.75   
				 # (Gao et al., 2016; Andraud et al., 2012; Chikaki and Ishikawa, 2009)
				probability = random.uniform(0.3, 0.75)
				if(random.uniform(0.0,1.0)<= probability):
					infectedMosquitoes.append(mosquito)
					mosquitoesContact[mosquito] = bited
					# print("Mosquito {} got infected by {} at time {}".format(mosquito, bited, currTime))
			else:
				# pHV Transmission probability from an infectious mosquito to a susceptible human per bite    0.1–0.75    
				# (Gao et al., 2016; Andraud et al., 2012; Chikaki and Ishikawa, 2009)

				# 1/fH    Duration of human latent period, E (days)   4   (Turmel et al., 2016; Bearcroft, 1956)
				if(mosquito in infectedMosquitoes and bited in susceptible):
					if(random.uniform(0.0,1.0) <= random.uniform(0.1,0.75)):
						exposed[bited] = currTime
						susceptible.remove(bited)
						edges.append((mosquitoesContact[mosquito], currentBiteList["bites"][i]))
						infectionsPerContact[mosquitoesContact[mosquito]].append(bited)
						# print("Human {} got infected by {} {} at time {}".format(currentBiteList["bites"][i], mosquito, mosquitoesContact[mosquito], currTime))
		removals = []
		for e in exposed:
			if(currTime >= exposed[e]+fourDays):
				infectedPeople[e] = currTime
				removals.append(e)
				# print("{} went from exposed to infected at {}".format(e,exposed[e]+fourDays))
		for r in removals:
			exposed.pop(r)


		removals = []
		for e in infectedPeople:
			if(currTime >= infectedPeople[e]+fourDays):
				recovered[e] = currTime
				removals.append(e)
				# print("{} went from infectious to recovered at time {}".format(e, infectedPeople[e]+fourDays))
		for r in removals:
			infectedPeople.pop(r)

		# UPDATE SEIR
		SEIR[currTime] = [len(susceptible), len(exposed), len(infectedPeople), len(recovered)]

		# print(edges)
		# Fin de simulación de epidemia

	infectionsR0 = {k : v for k, v in infectionsPerContact.items() if len(v)>0}
	for infected in randomInfected:
		if(infected not in infectionsR0):
			infectionsR0[infected] = []

	total = 0
	for r in infectionsR0:
		total += len(infectionsR0[r])

	r0 = total / len(infectionsR0.keys())
	# print("R0: {}".format(r0))
	return r0

if __name__ == "__main__":

	folderName = input("Enter folderName: ")
	outputFile = initFile(folderName.split("/")[-1])

	for file in os.listdir(folderName):
		filename = os.fsdecode(file)

		contactList, biteList, timeList = parseContacts("{}/{}".format(folderName, filename))

		for i in range(simulationsPerFile):
			r0 = simulateEpidemic(contactList, biteList, timeList)
			outputFile.write("{},{}\n".format(filename, r0))

	outputFile.close()