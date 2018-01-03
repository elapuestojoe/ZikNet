library(car)
library(Hmisc)
library(GGally)
library(ggplot2)

scatterplotMatrix(BahiaWeatherData[5:9])

#Eliminar coordenadas, fecha, preciProbability, precipIntensity
dataset = BahiaWeatherData[-1]
dataset = dataset[-1]
dataset = dataset[-1]
dataset = dataset[-1]
names(dataset)

round(cor(dataset),2) #Correlation matrix

datasetC <- as.matrix(dataset)
rcorr(datasetC, type=c("pearson","spearman"))

ggcorr(dataset, label=TRUE)

qplot(dataset$Searches, 
      dataset$Cases,
      data = dataset,
      geom = c("point", "smooth"),
      alpha = I(1/2))

qplot(dataset$Precipitacion,
      dataset$Casos,
      data = dataset,
      geom = c("point", "smooth"),
      alpha = I(1/2))

ggpairs(dataset,
        columns = c("Searches", "avgTemp", "humidity", "pressure", "Cases"),
        upper = list(continuous = wrap("cor", size = 10)),
        lower = list(continuous = "smooth"))



