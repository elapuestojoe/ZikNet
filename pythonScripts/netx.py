import networkx as nx
import matplotlib.pyplot as plt
import random
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

# Lo interesante, modelar la epidemia
timeListSortedKeys = sorted(timeList.keys())
exposed = {}
randomInfected = random.choice(contactList)
initialTime = 0 if len(timeListSortedKeys) == 0 else int(timeListSortedKeys[0])
infectedPeople = {randomInfected: initialTime}

susceptible = contactList.copy()
susceptible.remove(randomInfected)
recovered = {}
asymptomatic = {}
infectedMosquitoes = []

edges = []

# Proportion of individuals who are asymptomatic  0.80    (ZWG, 2016)
fourDays = 69120
for key in timeListSortedKeys:
    currentMosquitoes = timeList[key]
    currTime = int(key)
    for mosquito in currentMosquitoes:
        # Get time/bite
        currentBiteList = biteList[mosquito]
        i = currentBiteList["times"].index(key)
        bited = currentBiteList["bites"][i]
        
        if(bited in infectedPeople):
            # pVH Transmission probability from an infectious human to a susceptible mosquito per bite    0.3–0.75   
             # (Gao et al., 2016; Andraud et al., 2012; Chikaki and Ishikawa, 2009)
            probability = random.uniform(0.3, 0.75)
            if(random.random()<= probability):
                if(mosquito not in infectedMosquitoes):
                    infectedMosquitoes.append(mosquito)
        else:
            # pHV Transmission probability from an infectious mosquito to a susceptible human per bite    0.1–0.75    
            # (Gao et al., 2016; Andraud et al., 2012; Chikaki and Ishikawa, 2009)

            # 1/fH    Duration of human latent period, E (days)   4   (Turmel et al., 2016; Bearcroft, 1956)
            # 345600
            if(mosquito in infectedMosquitoes and bited in susceptible):
                # if(random.random()<= random.uniform(0.75,1)):
                if(random.random()<= random.uniform(0.25,0.5)):
                    exposed[bited] = currTime
                    susceptible.remove(bited)
                    edges.append((currentBiteList["bites"][0], currentBiteList["bites"][i]))

    removals = []
    for e in exposed:
        if(currTime >= exposed[e]+fourDays):
            infectedPeople[e] = currTime
            removals.append(e)
    for r in removals:
        exposed.pop(r)

    removals = []
    for e in infectedPeople:
        if(currTime >= infectedPeople[e]+fourDays):
            recovered[e] = currTime
            removals.append(e)
    for r in removals:
        infectedPeople.pop(r)

# print(edges)
# Fin de simulación de epidemia
print("S",susceptible)
print("E",exposed)
print("I",infectedPeople)
print("R",recovered)
# print("CURRENTTIME", timeListSortedKeys[-1])
draw_graph(contactList, edges, infectedPeople, susceptible, exposed, recovered)