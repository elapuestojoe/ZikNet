import networkx as nx
import matplotlib.pyplot as plt
import random
import numpy as np
from networkParser import parseContacts
import sys
import os.path
import os
import networkParser
import pandas as pd 

# 1 tick/5 minutes

def draw_graph(nodes, edges, infectedPeople, susceptible, exposed, recovered):

	# extract nodes from graph
	# nodes = set([n1 for n1, n2 in graph] + [n2 for n1, n2 in graph])

	# create networkx graph
	G=nx.DiGraph()

	# add nodes
	for node in nodes:
		G.add_node(node)
	# add edges
	for edge in edges:
		G.add_edge(edge[0], edge[1])

	# put colors
	color_map = []
	for node in G:
		if node in infectedPeople:
			color_map.append("red")
		elif node in susceptible:
			color_map.append("green")
		elif node in exposed:
			color_map.append("orange")
		elif node in recovered:
			color_map.append("yellow")

	# draw graph
	pos = nx.shell_layout(G)

	nx.draw_networkx_labels(G,pos)
	nx.draw(G, pos, node_color = color_map, with_labels=True)

	# show graph
	plt.show()

# draw example

def simulateEpidemic(filename):
	contactList, biteList, timeList = parseContacts(filename) # TEMP

	WARMUP = int(random.uniform(4000, 10000))
	# WARMUP = int(random.uniform(25000, 70000))

	infectionsPerContact = {}
	for i in contactList:
		infectionsPerContact[i] = []
	# Lo interesante, modelar la epidemia
	timeListSortedKeys = list(filter(lambda x: x > WARMUP,  sorted(timeList.keys())))

	# print(timeListSortedKeys)
	exposed = {}

	# Diccionario SEIR para plots
	SEIR = {}

	# infectar a 3 personas
	contactList = sorted(contactList)
	# print("contactList: {}".format(contactList))
	randomInfected = random.sample(contactList,3)
	
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
	def status():
		pass
		# print("S", susceptible)
		# print("E", exposed)
		# print("I", infectedPeople)
		# print("R", recovered)
		# print("-------------")
	# Initial conf
	# print("INITIAL CONFIGURATION")
	status()

	# Temp
	# draw_graph(contactList, edges, infectedPeople, susceptible, exposed, recovered)

	# print(timeListSortedKeys[0])
	# print(timeListSortedKeys[-1])
	# Proportion of individuals who are asymptomatic  0.80    (ZWG, 2016)
	fourDays = 1152
	threeDays = 864
	tenDays = 2880
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
				if(random.uniform(0.0,1.0) <= probability):
					infectedMosquitoes.append(mosquito)
					mosquitoesContact[mosquito] = bited
					# print("Mosquito {} got infected by {} at time {}".format(mosquito, bited, currTime))
			else:
				# pHV Transmission probability from an infectious mosquito to a susceptible human per bite    0.1–0.75    
				# (Gao et al., 2016; Andraud et al., 2012; Chikaki and Ishikawa, 2009)

				# 1/fH    Duration of human latent period, E (days)   4   (Turmel et al., 2016; Bearcroft, 1956)
				# 345600
				if(mosquito in infectedMosquitoes and bited in susceptible):
					if(random.uniform(0.0,1.0) <= random.uniform(0.1,0.75)):
						exposed[bited] = currTime
						susceptible.remove(bited)
						edges.append((mosquitoesContact[mosquito], currentBiteList["bites"][i]))
						infectionsPerContact[mosquitoesContact[mosquito]].append(bited)
						# print("Human {} got infected by {} {} at time {}".format(currentBiteList["bites"][i], mosquito, mosquitoesContact[mosquito], currTime))
						# status()
						# draw_graph(contactList, edges, infectedPeople, susceptible, exposed, recovered)
		removals = []
		for e in exposed:
			# https://www.sciencedirect.com/science/article/pii/S1755436517301093
			if(currTime >= exposed[e]+ (threeDays * 2) ):
			# if(currTime >= exposed[e]+ (threeDays * 1) ):
				infectedPeople[e] = currTime
				removals.append(e)
				# print("{} went from exposed to infected at {}".format(e,exposed[e]+fourDays))
				
		for r in removals:
			exposed.pop(r)
			# draw_graph(contactList, edges, infectedPeople, susceptible, exposed, recovered)


		removals = []
		for e in infectedPeople:
			if(currTime >= infectedPeople[e]+ (fourDays + threeDays)):
			# if(currTime >= infectedPeople[e]+ (fourDays)):
				recovered[e] = currTime
				removals.append(e)
				# print("{} went from infectious to recovered at time {}".format(e, infectedPeople[e]+fourDays))
		for r in removals:
			infectedPeople.pop(r)
			# draw_graph(contactList, edges, infectedPeople, susceptible, exposed, recovered)

		# UPDATE SEIR
		SEIR[currTime] = [len(susceptible), len(exposed), len(infectedPeople), len(recovered)]

	# Fin de simulación de epidemia
	# print("END")
	status()
	# print("INF", infectionsPerContact)

	# prueba 2 R0
	nodes = 0
	edg = 0
	for key in infectionsPerContact:
		if(len(infectionsPerContact[key]) > 0):
			nodes += 1
			edg += len(infectionsPerContact[key])
	r0 = 0
	if(edg != 0):
		r0 = edg / nodes

	# recoveredLength = len(recovered.keys())
	# total = 0
	# for key in recovered:
	# 	total += len(infectionsPerContact[key])
	# r0 = 0
	# if(recoveredLength > 0):
	# 	r0 = total / recoveredLength
		
	# print("TOTAL", total)
	# print("R0: {}".format(r0))
	def plotSEIR():
		keys = sorted(SEIR.keys())
		S = []
		E = []
		I = []
		R = []
		maxY = 0
		for key in keys:
			S.append(SEIR[key][0])
			E.append(SEIR[key][1])
			I.append(SEIR[key][2])
			R.append(SEIR[key][3])
			maxTempY = max(SEIR[key])
			if(maxTempY > maxY):
				maxY = maxTempY
		plt.plot(keys, S, "go")
		plt.plot(keys, E, "yo")
		plt.plot(keys, I, "ro")
		plt.plot(keys, R, "bo")
		plt.axis([0,keys[-1],0,maxY])
		plt.show()

	# draw_graph(contactList, edges, infectedPeople, susceptible, exposed, recovered)
	# plotSEIR()
	return r0

def performSimulation(filename):
	simulations = 1000
	results = []
	print(filename)
	for i in range(simulations):
		results.append(simulateEpidemic(filename))
	return results

if __name__ == '__main__':
	# filenames = ["10-0/CatemacoBaseline_HET 123813.xml", "10-0.10/CatemacoBaseline_HET 2838.xml", "10-0.20/CatemacoBaseline_HET 57016.xml", 
	# 	"10-0.30/CatemacoBaseline_HET 271103.xml"]

	results = {}
	folders = {
		# "10-0" : "10-0",
		# "10-0.10" 	: "10-0.10",
		# "10-0.20" 	: "10-0.20",

		# "15-0"		: "15-0",
		# "15-0.10"	: "15-0.10",
		# "15-0.20"	: "15-0.20",

		# "20-0"		: "20-0",
		# "20-0.10"	: "20-0.10",
		# "20-0.20"	: "20-0.20",

		# "25-0"		: "25-0",
		# "25-0.10"	: "25-0.10",
		# "25-0.20"	: "25-0.20",

		# "30-0"		: "30-0",
		# "30-0.10"	: "30-0.10",
		# # "30-0.20"	: "30-0.20",

		"GMAP0"		: "GMAP0",
		# "GMAP0.05"	: "GMAP0.05",
		"GMAP0.10" 	: "GMAP0.10",
		"GMAP0.20"	: "GMAP0.20",		

	}

	# folders = {
	# 	"GMAP0.00" 	: "GMAP0",
	# 	"GMAP0.10" 	: "GMAP0.10",
	# 	"GMAP0.20"	: "GMAP0.20",
	# 	"GMAP0.50"	: "GMAP0.50",
	# 	"GMAP0.70"	: "GMAP0.70",
	# 	"GMAP1.00"	: "GMAP1" 
	# }

	# folders = {
	# 	"BaseLine_HOM"			: "Datasets/CatemacoNetworks/CatemacoBaseline_HOM",
	# 	"Baseline_HET"			: "Datasets/CatemacoNetworks/CatemacoBaseline_HET",
	# 	"Fogging_HOM"			:  "Datasets/CatemacoNetworks/CatemacoFogging_HOM",
	# 	"Fogging_HET"			: "Datasets/CatemacoNetworks/CatemacoFogging_HET",
	# 	"Oxitec_HOM"			: "Datasets/CatemacoNetworks/CatemacoOxitec_HOM",
	# 	"Oxitec_HET"			: "Datasets/CatemacoNetworks/CatemacoOxitec_HET",
	# 	"Wolbachia_HOM"			: "Datasets/CatemacoNetworks/CatemacoWolbachia_HOM",
	# 	"Wolbachia_HET"		: "Datasets/CatemacoNetworks/CatemacoWolbachia_HET"
	# }

	for folderKey in folders:
		result = []
		folder = folders[folderKey]

		for i in range(2):
			filename = random.choice([file for file in os.listdir(folder)])
			result += performSimulation(folder+"/"+filename)

		results[folderKey] = result

	print(results)
	keys = []
	values = []
	for key in sorted(results.keys()):
		keys.append(key)
		values.append(results[key])

	df = pd.DataFrame(values, index=keys)
	df.T.boxplot(showmeans=True)
	plt.show()
	# print("Average R0", total/simulations)