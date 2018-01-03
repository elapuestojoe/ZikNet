library(readr)
library(tseries)
VeraCruzCasesTSR <- read_csv("E:/ZikNet/pythonScripts/VeraCruzCasesTSR.csv")
View(VeraCruzCasesTSR)

veracruzTS <- ts(VeraCruzCasesTSR, frequency = 52, start=c(2015, 47))
veracruzTS

veracruzSeriesdiff1 <- diff(veracruzTS, differences = 1)
plot.ts(veracruzSeriesdiff1)

veracruzSeriesdiff2 <- diff(veracruzTS, differences = 2)
plot.ts(veracruzSeriesdiff2)


library(forecast)
fitExp <- ets(veracruzTS)
summary(fitExp)

#fitArima <- auto.arima(veracruzTS)

#Check seasonality
count_ma = ts(na.omit(VeraCruzCasesTSR$Cases), frequency = 52)
decomp = stl(count_ma, s.window="periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)

#check stationary
adf.test(count_ma, alternative = "stationary")

Acf(count_ma, main="")

Pacf(count_ma, main="")

fitArima <- auto.arima(deseasonal_cnt, seasonal=FALSE)
fitArima
tsdisplay(residuals(fitArima), lag.max=45, main='(1,1,4) Model Residuals')

fcast <- forecast(fitArima, h= 52)
plot(fcast)

#Ahora modelo con seasonality
fit_w_seasonality = auto.arima(veracruzTS, seasonal = TRUE)
fit_w_seasonality
seas_fcast <- forecast(fit_w_seasonality, h=12)
plot(seas_fcast)