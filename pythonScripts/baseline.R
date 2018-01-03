library(caret)
model <- VeracruzWeatherDataCopy
inTrain <- createDataPartition(y=model$Casos, p=0.7, list=FALSE)
trainingSet <- model[inTrain,]
testingSet <- model[-inTrain,]

best.guess <- mean(trainingSet$Casos)

RMSE.baseline <- mean(abs(best.guess-testingSet$Casos))
RMSE.baseline

MAE.baseline <- mean(abs(best.guess-testingSet$Casos))
MAE.baseline