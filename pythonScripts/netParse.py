import xml.etree.ElementTree

e = xml.etree.ElementTree.parse('CatemacoBaseline_HET 41898.xml').getroot()

# for atype in e.findall('final_outputs'):
#     print(atype.get('output'))

final_outputs = e.find('final_outputs')

biteList = None
for child in final_outputs:
	print(child.tag, child.attrib)

	if(child.attrib["id"]=="biteList"):
		print(child.text)