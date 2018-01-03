library(ISLR); library(ggplot2); library(caret)
pairs(~Casos+Busquedas+Precipitacion+avgTemp+precipProbability, data=VeracruzWeatherDataCopy)

model = VeracruzWeatherDataCopy
fit <- lm(Casos ~ Busquedas+Precipitacion+avgTemp+precipProbability, data=model)
inTrain <- createDataPartition(y=model$Casos, p=0.7, list=FALSE)
trainingSet <- model[inTrain,]
testingSet <- model[-inTrain,]

dim(trainingSet);dim(testingSet)

TrainingModel <- lm(Casos ~ Busquedas+Precipitacion+avgTemp+precipProbability, data=trainingSet)
summary(TrainingModel)

predict(TrainingModel, testingSet, interval="predict")

CheckModel <- train(Casos ~ Busquedas+Precipitacion+avgTemp+precipProbability, data=trainingSet, method="lm")
DoubleCheckModel<-CheckModel$finalModel
plot(DoubleCheckModel,1,pch=19,cex=0.5)

#Test
TestingModel<-lm(Casos ~ Busquedas+Precipitacion+avgTemp+precipProbability, data=testingSet)
sqrt(sum((TrainingModel$fitted-trainingSet$Casos)^2))
sqrt(sum((TestingModel$fitted-testingSet$Casos)^2))