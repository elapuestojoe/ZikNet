import networkx as nx
import matplotlib.pyplot as plt
import random
from netParse import parseContacts

def draw_graph(nodes, edges, infectedPeople):

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
        else:
            color_map.append("green")

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
infectedPeople = [random.choice(contactList)]
infectedMosquitoes = []
probabilityOfTransimission = 0.05
edges = []
timeListSortedKeys = sorted(timeList.keys())
print(infectedPeople)
for key in timeListSortedKeys:
    currentMosquitoes = timeList[key]

    for mosquito in currentMosquitoes:
        # Get time/bite
        currentBiteList = biteList[mosquito]
        i = currentBiteList["times"].index(key)
        bited = currentBiteList["bites"][i]
        
        if(bited in infectedPeople):
            # Random prob of mosquito getting infected
            if(random.random()<= probabilityOfTransimission):
                if(mosquito not in infectedMosquitoes):
                    infectedMosquitoes.append(mosquito)
        else:
            if(mosquito in infectedMosquitoes and bited not in infectedPeople):
                infectedPeople.append(bited)
                edges.append((currentBiteList["bites"][i-1], currentBiteList["bites"][i]))

print(edges)
print(infectedMosquitoes)
# Fin de simulación de epidemia
print(infectedMosquitoes)
draw_graph(contactList, edges, infectedPeople)