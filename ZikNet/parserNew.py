def parseImproved():
	file = open("data/CatemacoBaseline_HET 55133BITES.txt", "r")
	contacts = set()
	biteList = {}
	timeList = {}

	for line in file:
		line = line[1:-2] #remove []
		line = line.replace("{", "")
		line = line.replace("}", "")
		line = line.split(" ")
		times = []
		bites = []
		for i in range(1, len(line)):
			info = line[i].split(",")
			bites.append(info[0])
			times.append(int(info[1]))



			contacts.add(info[0])
			if(info[1] not in timeList):
				timeList[int(info[1])] = [line[0]]
			else:
				timeList[int(info[1])].append(line[0])

		biteList[line[0]] = {"bites": bites, "times": times}

	return contacts, biteList, timeList

if __name__ == '__main__':
	contacts, biteList, timeList = parseImproved()