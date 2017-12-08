library(randomForest)
library(ISLR); library(ggplot2); library(caret)

inTrain <- createDataPartition(y=model$Casos, p=0.7, list=FALSE)
trainingSet <- model[inTrain,]
testingSet <- model[-inTrain,]

set.seed(123)

rf <- randomForest(Casos ~ Busquedas + Precipitacion + Temp + Altura, data=trainingSet, importance=TRUE, ntree=1000)

which.min(rf$mse)

#Plot error as a function of the number of trees
plot(rf) 

imp <- as.data.frame(sort(importance(rf)[,1],decreasing = TRUE),optional = T)
names(imp) <- "% Inc MSE"
imp

#Test
test.pred.forest <- predict(rf,testingSet)
RMSE.forest <- sqrt(mean((test.pred.forest-testingSet$Casos)^2))
RMSE.forest

MAE.forest <- mean(abs(test.pred.forest-testingSet$Casos))
MAE.forest