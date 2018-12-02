import pandas

obj = pandas.read_excel(
	io="excel_files/Epi-02.xlsx", 
	header=0,
	skip_footer=1,
	# thousands=" ",
	index_col=0)["Total"]

columns = obj.index
c = {}
for i in range(len(columns)):
	# c.append(columns[i].strip().replace(" ", "").replace("\n", "").upper())
	c[columns[i].strip().replace(" ", "").replace("\n", "").upper()] = obj[columns[i]]

print(c)