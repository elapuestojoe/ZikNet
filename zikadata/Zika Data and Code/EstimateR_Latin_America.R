#################################################################################
# This code is part of the paper "Invasion dynamics of Zika in Latin America"
# published in Science in July 2016. It estimates the instantaneous reproduction
# number R for all Latin American countries in  folder CSV Data Files.
#################################################################################

rm(list=ls())

library(EpiEstim)

# Set approppriate working directory 
setwd("C:/.../CSV Data Files/")

# Read in the data 
dat <- read.csv("TimeWindows_Latin_America.csv", header = TRUE)

# Set time windows start and end 
Tw.length <- 4  # 5-weeks time windows used
T.start.2 <- dat$T.end - Tw.length 
T.end.1 <- dat$T.start + Tw.length
T.end.2 <- T.start.2 + Tw.length

# Estimate R for each country
for(i in 1:length(dat$country)) 
{
	data <- read.csv(as.character(dat$file[i]), header = TRUE)
	data$total[is.na(data$total)] <- 0

	res <- EstimateR(data$total[1:dat$T.end[i]],
					 T.Start = dat$T.start[i]:T.start.2[i],
 			         T.End = T.end.1[i]:T.end.2[i],
					 method = "UncertainSI",
					 Mean.SI = 20.0/7,
					 Std.Mean.SI = 2.535/7,
					 Min.Mean.SI = 7/7,
					 Max.Mean.SI = 33/7,
					 Std.SI = 7.4/7,
					 Std.Std.SI = 1.586/7,
					 Min.Std.SI = 1/7,
					 Max.Std.SI = 13.8/7,
					 n1 = 1000,
					 n2 = 100,
					 plot = FALSE)

	assign(paste("R_estimates", dat$country[i],sep="_"), res)
}

# Collate estimates in tab.final
for(i in 1:length(dat$country)){

	tab <- get(paste("R_estimates", dat$country[i], sep="_"))$R[, c(1,2,3,5,11)]
	colnames(tab)[c(3,4,5)] <- c("Mean_R", "Quantile_2.5","Quantile_97.5")

	tab$Country <- dat$country[i]
	tab$DistribSI <- "Gamma"

	if(i == 1) {
		tab.final <- tab[, c(6,7,1:5)]
	} else {
		tab <- tab[, c(6,7,1:5)]
		tab.final <- rbind(tab.final, tab)
	}
}

# Specify 5-weeks time windows
for(i in 1:length(dat$country)) 
{
	data <- read.csv(as.character(dat$file[i]), header = TRUE)
	country <- as.character(unique(data$country))

	tab.final$T.Start.abs[tab.final$Country == country] <- as.character(data$date[tab.final$T.Start[tab.final$Country == country]])
	tab.final$T.End.abs[tab.final$Country == country] <- as.character(data$date[tab.final$T.End[tab.final$Country == country]])
}
tab.final <- tab.final[,c(1,2,8,9,5:7)]


# Output results
write.csv(tab.final, file = "R_estimates_Latin_America.csv", quote = FALSE, eol = "\n", row.names = FALSE)

