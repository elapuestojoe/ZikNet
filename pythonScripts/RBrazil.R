
plot(BahiaBrazil$BahiaSearches, BahiaBrazil$BahiaCases)

x <- BahiaBrazil$BahiaSearches
y <- BahiaBrazil$BahiaCases

scatter.smooth(x, y, main="Cases ~ Searches")  # scatterplot

#Boxplot outliers

par(mfrow=c(1, 2))
boxplot(x, 
        main="Searches", 
        sub=paste("Outlier rows: ", boxplot.stats(x)$out))
        # box plot for 'speed'

boxplot(y,
        main="Cases",
        sub=paste("Outlier rows: ",boxplot.stats(y)$out))
        # box plot for 'distance'

#Density plot
library(e1071)
par(mfrow=c(1, 2))  # divide graph area in 2 columns

plot(density(x),
     main="Density Plot: Searches",
     ylab="Frequency",
     sub=paste("Skewness:",round(e1071::skewness(x), 2)))
     # density plot for 'speed'
polygon(density(x), col="red")

plot(density(y),
     main="Density Plot: Cases",
     ylab="Frequency",
     sub=paste("Skewness:", round(e1071::skewness(y), 2)))
     # density plot for 'dist'
polygon(density(y), col="red")

#Correlation
cor(x, y)

#Build linear model
linearMod <- lm(BahiaCases ~ BahiaSearches, data=BahiaBrazil)  # build linear regression model on full data
print(linearMod)
summary(linearMod)

#t-statistic
modelSummary <- summary(linearMod)  # capture model summary as an object
modelCoeffs <- modelSummary$coefficients  # model coefficients
beta.estimate <- modelCoeffs["BahiaSearches", "Estimate"]  # get beta estimate for speed
std.error <- modelCoeffs["BahiaSearches", "Std. Error"]  # get std.error for speed
t_value <- beta.estimate/std.error  # calc t statistic
p_value <- 2*pt(-abs(t_value), df=nrow(BahiaBrazil)-ncol(BahiaBrazil))  # calc p Value
f_statistic <- linearMod$fstatistic[1]  # fstatistic
f <- summary(linearMod)$fstatistic  # parameters for model p-value calc
model_p <- pf(f[1], f[2], f[3], lower=FALSE)

t_value
p_value
f
model_p

#AIC and BIC
AIC(linearMod)
BIC(linearMod)

#Train
set.seed(100)  # setting seed to reproduce results of random sampling
trainingRowIndex <- sample(1:nrow(BahiaBrazil), 0.8*nrow(BahiaBrazil))  # row indices for training data
trainingData <- BahiaBrazil[trainingRowIndex, ]  # model training data
testData  <- BahiaBrazil[-trainingRowIndex, ]   # test data

lmMod <- lm(BahiaCases ~ BahiaSearches, data=trainingData)  # build the model
casesPred <- predict(lmMod, testData)  # predict cases

summary(lmMod)
AIC (lmMod)

actuals_preds <- data.frame(cbind(actuals=testData$BahiaCases, 
                                  predicteds=casesPred))
  # make actuals_predicteds dataframe.
correlation_accuracy <- cor(actuals_preds)
head(actuals_preds)

min_max_accuracy <- mean(apply(actuals_preds, 1, min) / apply(actuals_preds, 1, max))  
min_max_accuracy
mape <- mean(abs((actuals_preds$predicteds - actuals_preds$actuals))/actuals_preds$actuals) 
mape

#Corregir
plot(casesPred, testData$BahiaCases, xlab="Predicted", ylab="Actual")
abline(a=0,b=1)