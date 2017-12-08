library(ISLR); library(ggplot2); library(caret)
pairs(~Casos+Busquedas+Precipitacion+Temp+Altura, data=model)

fit <- lm(Casos ~ Busquedas+Precipitacion+Temp, data=model)
inTrain <- createDataPartition(y=model$Casos, p=0.7, list=FALSE)
trainingSet <- model[inTrain,]
testingSet <- model[-inTrain,]

dim(trainingSet);dim(testingSet)

#Modelo logarítmico
#lin.reg <- lm(log(Casos+1) ~ Busquedas + Precipitacion + Temp + Altura, data=trainingSet)
lin.reg <- lm(log(Casos+1) ~ Busquedas + Precipitacion + Temp, data = trainingSet)
summary(lin.reg)

#Predecir, exponenciar
test.pred.lin <- exp(predict(lin.reg,testingSet))-1

#Error cuadrático
RMSE.lin.reg <- sqrt(mean((test.pred.lin-testingSet$Casos)^2))
RMSE.lin.reg

MAE.lin.reg <- mean(abs(test.pred.lin-testingSet$Casos))
MAE.lin.reg

