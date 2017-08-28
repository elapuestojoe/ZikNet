data2 <- file("~/ZikNet/RScripts/final.txt")
mylist2 <- strsplit(readLines(data2), ",")
mylist2 <- lapply(mylist2, as.character)
close(data2)

library(igraph)

test <- unlist(mylist2)
network <- graph(edges = c(test), directed = TRUE)

plot(network)

out.deg.network <- degree(network,v=V(network),mode="out")

out.deg.network
meanDegree <- Reduce(`+`,out.deg.network)/length(out.deg.network)
meanDegree

deg.distr<-degree.distribution(network,cumulative=T,mode="out")

# Then I can plot the degree distribution
plot(deg.distr,log="xy",
     ylim=c(.01,10),
     bg="black",pch=21,
     xlab="Degree",
     ylab="Cumulative Frequency")

# Diameter is essentially the longest path between two vertices
diameter(network)