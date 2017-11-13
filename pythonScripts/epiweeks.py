import datetime

# Right now it only works for 2017

# An epidemiological week, commonly referred to as an epi week or a CDC week, 
# is simply a standardized method of counting weeks to allow for the comparison of data year after year.
# Definition
# The first epi week of the year ends, by definition, on the first Saturday of January, 
# as long as it falls at least four days into the month. Each epi week begins on a Sunday 
# and ends on a Saturday.

def getFirstSundayEpiWeek(year):
	month = 1
	day = 1
	day += 7 - datetime.datetime(year,month,day).isocalendar()[2] #daynumber

	if(day > 4):
		year -= 1
		month = 12
		day = 31 - (7-day)
	return datetime.datetime(year,month,day)

def getEpidemiologicalWeeks(year):
	start = getFirstSundayEpiWeek(year)
	nextWeek = getNextWeek(start)
	weeks = [start]
	for i in range(51):
		weeks.append(nextWeek)
		nextWeek = getNextWeek(nextWeek)
	return weeks

def getYMD(timeframe):
	return "{}/{}/{}".format(timeframe.day,timeframe.month,timeframe.year)

def getNextWeek(timeframe):
	return timeframe+datetime.timedelta(days=7)