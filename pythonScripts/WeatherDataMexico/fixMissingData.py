import datetime
import pandas as pd
def formatDate(dateString):
	dateArray = [int(i) for i in dateString.split("-")]
	return datetime.datetime(dateArray[0], dateArray[1], dateArray[2])

def dateToStr(date):
	return "{}-{:02}-{:02}".format(date.year,date.month,date.day)
filename = input("Enter filename: ")

data = pd.read_csv(filename)

dates = data["date"].values

startDate = formatDate(dates[0])
endDate = formatDate(dates[-1])

while startDate < endDate:
	
	if(dateToStr(startDate) not in dates):
		print("Missing {}".format(startDate))

	startDate = startDate + datetime.timedelta(days=1)
