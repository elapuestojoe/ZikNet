library('ggplot2')
library('forecast')
library('tseries')

library(readr)
model <- read_csv("E:/ZikNet/pythonScripts/model.csv")

pairs(~Casos+Busquedas+Precipitacion+Temp+Altura, data=model)

