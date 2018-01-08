# Script para corregir csv's corruptos (error excel)
# XML-write-tick-outputs EXPORT_RATE
temp = open("TempPromedio2016.csv", "r")
f = open("TempCorrected", "w")

for line in temp:
	n = line.split()
	f.write(",".join(n))
	f.write("\n")
temp.close()
f.close()