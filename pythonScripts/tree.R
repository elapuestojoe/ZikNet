library(rpart)
library(rattle)
library(ISLR); library(ggplot2); library(caret)

model <- VeracruzWeatherDataCopy
inTrain <- createDataPartition(y=model$Casos, p=0.7, list=FALSE)
trainingSet <- model[inTrain,]
testingSet <- model[-inTrain,]


rt <- rpart(Casos ~ Busquedas+Precipitacion+avgTemp+precipProbability, data=trainingSet)

#Visualizar arbol
fancyRpartPlot(rt)

test.pred.rtree <- predict(rt, testingSet)

RMSE.rtree <- sqrt(mean((test.pred.rtree-testingSet$Casos)^2))
RMSE.rtree

MAE.rtree <- mean(abs(test.pred.rtree-testingSet$Casos))
MAE.rtree

#Prune
# Check cross-validation results (xerror column)
# It corresponds to 2 splits and cp = 0.088147
printcp(rt)

#Get optimal CP
min.xerror <- rt$cptable[which.min(rt$cptable[,"xerror"]),"CP"]
min.xerror

#Prune
rt.pruned <- prune(rt,cp = min.xerror) 
fancyRpartPlot(rt.pruned)


#Test
test.pred.rtree.p <- predict(rt.pruned,testingSet)
RMSE.rtree.pruned <- sqrt(mean((test.pred.rtree.p-testingSet$Casos)^2))
RMSE.rtree.pruned

MAE.rtree.pruned <- mean(abs(test.pred.rtree.p-testingSet$Casos))
MAE.rtree.pruned