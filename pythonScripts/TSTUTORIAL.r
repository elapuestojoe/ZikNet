library(readr)
VeraCruzCasesTSR <- read_csv("E:/ZikNet/pythonScripts/VeraCruzCasesTSR.csv")
View(VeraCruzCasesTSR)

veracruzTS <- ts(VeraCruzCasesTSR, frequency = 52, start=c(2015, 47))
veracruzTS

plot.ts(veracruzTS)

logVeracruzTS <- (log(veracruzTS+1))
plot.ts(logVeracruzTS)

#irregular so use TTR

library(TTR)

# Try Simple moving average and 8 previous values
veracruzTSSMA3 <- SMA(veracruzTS, n=8)
plot.ts(veracruzTSSMA3)

#Decompose it to trend, seasonal and irregular components

veracruzDecomposed <- decompose(veracruzTS)
plot(veracruzDecomposed)

#Seasonally adjusting (remove seasonal from original model)

veracruzTSSeasonallyAdjusted <- veracruzTS - veracruzDecomposed$seasonal
plot(veracruzTSSeasonallyAdjusted)


#Simple exponential Smoothing
veracruzForecasts <- HoltWinters(veracruzTS, beta=FALSE, gamma=FALSE)
veracruzForecasts

veracruzForecasts$fitted

plot(veracruzForecasts)

veracruzForecasts$SSE #sum of squared errors

# FORECAST
library("forecast")
veracruzForecasts2 <- forecast(veracruzForecasts, h=8)
veracruzForecasts2

plot(forecast(veracruzForecasts2))

#Calculate correlogram to determine if accuracy could be improved with other models
acf(veracruzForecasts2$residuals[-1], lag.max = 20)

Box.test(veracruzForecasts2$residuals, lag=20, type="Ljung-Box")

#P value bajo 

plot.ts(veracruzForecasts2$residuals)

#plot errors
plotForecastErrors <- function(forecasterrors)
{
  # make a histogram of the forecast errors:
  mybinsize <- IQR(forecasterrors)/4
  mysd   <- sd(forecasterrors)
  mymin  <- min(forecasterrors) - mysd*5
  mymax  <- max(forecasterrors) + mysd*3
  # generate normally distributed data with mean 0 and standard deviation mysd
  mynorm <- rnorm(10000, mean=0, sd=mysd)
  mymin2 <- min(mynorm)
  mymax2 <- max(mynorm)
  if (mymin2 < mymin) { mymin <- mymin2 }
  if (mymax2 > mymax) { mymax <- mymax2 }
  # make a red histogram of the forecast errors, with the normally distributed data overlaid:
  mybins <- seq(mymin, mymax, mybinsize)
  hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
  # freq=FALSE ensures the area under the histogram = 1
  # generate normally distributed data with mean 0 and standard deviation mysd
  myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
  # plot the normal curve as a blue line on top of the histogram of forecast errors:
  points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
}

plotForecastErrors(veracruzForecasts2$residuals[-1])
