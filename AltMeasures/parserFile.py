import sys
import xml.etree.ElementTree
import json

def ParseTicks(filename):
	e = xml.etree.ElementTree.parse(filename).getroot()

	ticks = e.find('ticks_outputs')

	ticksDiccionary = {}

	for child in ticks:

		idTick = int(child.attrib["id"])
		tick = {}

		for attribute in child:
			if("E" in attribute.text):
				values = [float(i) for i in attribute.text.split("E")]
				tick[attribute.attrib["id"]] = float(values[0]*(10^int(values[1])))
			else:
				tick[attribute.attrib["id"]] = float(attribute.text)

		ticksDiccionary[idTick] = tick

	return ticksDiccionary

if __name__ == '__main__':
	ParseTicks("./DATA/10-0/CatemacoBaseline_HET 257082.xml")