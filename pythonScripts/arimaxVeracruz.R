library(readr)
library(ggplot2)
veracruz <- read_csv("E:/ZikNet/pythonScripts/veracruzModel.csv")
#veracruz <- VeracruzWeatherDataCopy
View(veracruz)

####################
#                  #
#    Exercise 1    #
#                  #
####################
require(ggplot2)
require(gridExtra)

#df <- read_csv("E:/ZikNet/pythonScripts/veracruzModel.csv")
df <- veracruz
X <- veracruz$Casos
p1 <- ggplot(df, aes(x = X, y = Busquedas)) +
  ylab("Busquedas") +
  xlab("") +
  geom_line() +
  expand_limits(x = 0, y = 0)

p2 <- ggplot(df, aes(x = X, y = Precipitacion)) +
  ylab("Precipitacion") +
  xlab("") +
  geom_line() +
  expand_limits(x = 0, y = 0)

p3 <- ggplot(df, aes(x = X, y = Temp)) +
  ylab("precipitacion") +
  xlab("Period") +
  geom_line() +
  expand_limits(x = 0, y = 0)

grid.arrange(p1, p2, p3)

####################
#                  #
#    Exercise 2    #
#                  #
####################
require(forecast)
fit_cons <- auto.arima((df$Casos))
fcast_cons <- forecast(fit_cons, h = 2)

####################
#                  #
#    Exercise 3    #
#                  #
####################
require(forecast)
autoplot(fcast_cons)

####################
#                  #
#    Exercise 4    #
#                  #
####################
require(forecast)
accuracy(fit_cons)

####################
#                  #
#    Exercise 5    #
#                  #
####################
require(forecast)
fit_cons_busquedas <- auto.arima(df$Casos, xreg = df$Busquedas)
fcast_busquedas <- c(9, 12) #Busquedas siguientes
fcast_cons_busquedas <- forecast(fit_cons_busquedas, xreg = fcast_busquedas, h = 2)
autoplot(fcast_cons_busquedas)

#Comparar

####################
#                  #
#    Exercise 6    #
#                  #
####################
summary(fcast_cons_busquedas)

####################
#                  #
#    Exercise 7    #
#                  #
####################
require(lmtest)
coeftest(fit_cons_busquedas)

####################
#                  #
#    Exercise 8    #
#                  #
####################
busquedas_column <- matrix(df$Busquedas, ncol = 1)
precipitacion <- c(NA, NA, df$Precipitacion)
precipitacion_matrix <- embed(precipitacion, 3)
vars_matrix <- cbind(busquedas_column, precipitacion_matrix)
print(vars_matrix)

####################
#                  #
#    Exercise 9    #
#                  #
####################
require(forecast)
fit_vars_0 <- auto.arima(df$Casos, xreg = vars_matrix[, 1:2])
fit_vars_1 <- auto.arima(df$Casos, xreg = vars_matrix[, 1:3])
fit_vars_2 <- auto.arima(df$Casos, xreg = vars_matrix[, 1:4])
print(fit_vars_0$aic)
print(fit_vars_1$aic)
print(fit_vars_2$aic)
