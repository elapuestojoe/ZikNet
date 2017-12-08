library(readr)
library(ggplot2)
Icecream <- read_csv("E:/ZikNet/ArimaxExample/Icecream.csv")
View(Icecream)

####################
#                  #
#    Exercise 1    #
#                  #
####################
require(ggplot2)
require(gridExtra)

df <- read.csv("E:/ZikNet/ArimaxExample/Icecream.csv")

p1 <- ggplot(df, aes(x = X, y = cons)) +
  ylab("Consumption") +
  xlab("") +
  geom_line() +
  expand_limits(x = 0, y = 0)

p2 <- ggplot(df, aes(x = X, y = temp)) +
  ylab("Temperature") +
  xlab("") +
  geom_line() +
  expand_limits(x = 0, y = 0)

p3 <- ggplot(df, aes(x = X, y = income)) +
  ylab("Income") +
  xlab("Period") +
  geom_line() +
  expand_limits(x = 0, y = 0)

grid.arrange(p1, p2, p3, ncol=1, nrow=3)

####################
#                  #
#    Exercise 2    #
#                  #
####################
require(forecast)
fit_cons <- auto.arima(df$cons)
fcast_cons <- forecast(fit_cons, h = 6)

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
fit_cons_temp <- auto.arima(df$cons, xreg = df$temp)
fcast_temp <- c(70.5, 66, 60.5, 45.5, 36, 28)
fcast_cons_temp <- forecast(fit_cons_temp, xreg = fcast_temp, h = 6)
autoplot(fcast_cons_temp)

####################
#                  #
#    Exercise 6    #
#                  #
####################
summary(fcast_cons_temp)

####################
#                  #
#    Exercise 7    #
#                  #
####################
require(lmtest)
coeftest(fit_cons_temp)

####################
#                  #
#    Exercise 8    #
#                  #
####################
temp_column <- matrix(df$temp, ncol = 1)
income <- c(NA, NA, df$income)
income_matrix <- embed(income, 3)
vars_matrix <- cbind(temp_column, income_matrix)
print(vars_matrix)

####################
#                  #
#    Exercise 9    #
#                  #
####################
require(forecast)
fit_vars_0 <- auto.arima(df$cons, xreg = vars_matrix[, 1:2])
fit_vars_1 <- auto.arima(df$cons, xreg = vars_matrix[, 1:3])
fit_vars_2 <- auto.arima(df$cons, xreg = vars_matrix[, 1:4])
print(fit_vars_0$aic)
print(fit_vars_1$aic)
print(fit_vars_2$aic)

####################
#                  #
#    Exercise 10   #
#                  #
####################
require(forecast)
expected_temp_income <- matrix(c(fcast_temp, 91, 91, 93, 96, 96, 96),
                               ncol = 2, nrow = 6)
fcast_cons_temp_income <- forecast(fit_vars_0,
                                   xreg = expected_temp_income,
                                   h = 6)
autoplot(fcast_cons_temp_income)

accuracy(fit_cons)[, "MASE"]
accuracy(fit_cons_temp)[, "MASE"]
accuracy(fit_vars_0)[, "MASE"]


