
filteredModelByState <- modelMexico_2015_2017[modelMexico_2015_2017$CITY=="Mexico-Tamaulipas",]
filteredModelByYear <- dplyr::filter(filteredModelByState, grepl("2017", Date))

plot(filteredModelByYear$Searches, filteredModelByYear$Cases)

x <- filteredModelByYear$Searches
y <- filteredModelByYear$Cases

m <- nls(y~a*x/(b+x))
#get some estimation of goodness of fit
cor(y,predict(m))

#plot
plot(x,y)
lines(x,predict(m),lty=2,col="red",lwd=3)