import networkx as nx
import matplotlib.pyplot as plt
import random
import numpy as np
from netParse import parseContacts

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
# graph = [(20, 21),(21, 22),(22, 23), (23, 24),(24, 25), (25, 20)]

contactList, biteList, timeList = parseContacts()

infectionsPerContact = {}
for i in contactList:
    infectionsPerContact[i] = []
# Lo interesante, modelar la epidemia
timeListSortedKeys = sorted(timeList.keys())
exposed = {}

# Diccionario SEIR para plots
SEIR = {}

# infectar a 2 personas
randomInfected = random.sample(contactList,2)
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
    print("S", susceptible)
    print("E", exposed)
    print("I", infectedPeople)
    print("R", recovered)
    print("-------------")
# Initial conf
print("INITIAL CONF")
status()
# Proportion of individuals who are asymptomatic  0.80    (ZWG, 2016)
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
                print("Mosquito {} got infected by {} at time {}".format(mosquito, bited, currTime))
        else:
            # pHV Transmission probability from an infectious mosquito to a susceptible human per bite    0.1–0.75    
            # (Gao et al., 2016; Andraud et al., 2012; Chikaki and Ishikawa, 2009)

            # 1/fH    Duration of human latent period, E (days)   4   (Turmel et al., 2016; Bearcroft, 1956)
            # 345600
            if(mosquito in infectedMosquitoes and bited in susceptible):
                if(random.uniform(0.0,1.0)<= random.uniform(0.75,1)):
                    exposed[bited] = currTime
                    susceptible.remove(bited)
                    edges.append((mosquitoesContact[mosquito], currentBiteList["bites"][i]))
                    infectionsPerContact[mosquitoesContact[mosquito]].append(bited)
                    print("Human {} got infected by {} {} at time {}".format(currentBiteList["bites"][i], mosquito, mosquitoesContact[mosquito], currTime))
                    status()
    removals = []
    for e in exposed:
        if(currTime >= exposed[e]+fourDays):
            infectedPeople[e] = currTime
            removals.append(e)
            print("{} went from exposed to infeced at {}".format(e,exposed[e]+fourDays))
    for r in removals:
        exposed.pop(r)


    removals = []
    for e in infectedPeople:
        if(currTime >= infectedPeople[e]+fourDays):
            recovered[e] = currTime
            removals.append(e)
            print("{} went from infectious to recovered at time {}".format(e, infectedPeople[e]+fourDays))
    for r in removals:
        infectedPeople.pop(r)

    # UPDATE SEIR
    SEIR[currTime] = [len(susceptible), len(exposed), len(infectedPeople), len(recovered)]

# print(edges)
# Fin de simulación de epidemia
print("END")
status()
print(infectionsPerContact)
r0 = 0
for r in recovered:
    r0+= len(infectionsPerContact[r])
r0/= len(recovered)
print("R0",r0)

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
plotSEIR()
# print("CURRENTTIME", timeListSortedKeys[-1])
draw_graph(contactList, edges, infectedPeople, susceptible, exposed, recovered)