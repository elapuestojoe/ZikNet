#data2 <- file("~/ZikNet/RScripts/final.txt")
data2 <- file("E:/ZikNet/RScripts/final.txt")
mylist2 <- strsplit(readLines(data2), ",")
mylist2 <- lapply(mylist2, as.character)
close(data2)

library(igraph)
library(NetIndices)
library(EpiModel)

test <- unlist(mylist2)
network <- graph(edges = c(test), directed = TRUE)

network

plot(network)

# Initialize the network
nw <- network.initialize(n = 30, directed = TRUE)
nw

plot(nw)

 