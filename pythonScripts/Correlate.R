library(ISLR); library(ggplot2); library(caret)
pairs(~Casos+Busquedas+Precipitacion+Temp+Altura, data=model)

fit <- lm(Casos ~ Busquedas+Precipitacion+Temp+Altura, data=model)
inTrain <- createDataPartition(y=model$Casos, p=0.7, list=FALSE)
trainingSet <- model[inTrain,]
testingSet <- model[-inTrain,]

dim(trainingSet);dim(testingSet)

TrainingModel <- lm(Casos ~ Busquedas+Precipitacion+Temp, data=trainingSet)
summary(TrainingModel)

predict(TrainingModel, testingSet, interval="predict")

CheckModel <- train(Casos ~ Busquedas+Precipitacion+Temp, data=trainingSet, method="lm")
DoubleCheckModel<-CheckModel$finalModel
plot(DoubleCheckModel,1,pch=19,cex=0.5)

#Test
TestingModel<-lm(Casos ~ Busquedas+Precipitacion+Temp, data=testingSet)
sqrt(sum((TrainingModel$fitted-trainingSet$Casos)^2))
sqrt(sum((TestingModel$fitted-testingSet$Casos)^2))