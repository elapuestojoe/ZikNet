library(readr)
VeraCruzCasesTSR <- read_csv("E:/ZikNet/pythonScripts/VeraCruzCasesTSR.csv")
View(VeraCruzCasesTSR)

veracruzTS <- ts(VeraCruzCasesTSR, frequency = 52, start=c(2015, 47))
plot.ts(veracruzTS)

veracruzSeriesForecasts <- HoltWinters(veracruzTS, gamma=FALSE)
veracruzSeriesForecasts

plot(veracruzSeriesForecasts)