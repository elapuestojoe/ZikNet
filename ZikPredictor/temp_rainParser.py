def ParseFile(fileName):
	header = None
	diccionario = {}
	file = open(fileName)
	for line in file:
		if header is None:
			header = line.strip().split(",")[1:]
		else:
			line = line.strip().split(",")
			diccionario[line[0]] = {}
			for i in range(1, len(line)):
				diccionario[line[0]][header[i-1]] = line[i]
	file.close()
	return diccionario