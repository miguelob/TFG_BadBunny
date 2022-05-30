library(arules)
library(arulesViz)
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(plyr)
library(dplyr)
library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization
library(dummies)  #for creration of dummy variables
library(caret)     #for confusion matrix
library(RSNNS)     #for normalization


data<-read.csv('discografia.csv',sep=',',stringsAsFactors=T)
data$Track <- NULL
set.seed(3141592) 
index <- sample(nrow(data), round(0.1*nrow(data)))
data <- data[index,] 
summary(data)


### ========== REGLAS DE ASOCIACIÓN =============
# transactionData <- ddply(data,c("housing_median_age","total_rooms","median_income","ocen_proximity"),
#                          function(df1)paste(df1$Description,
#                                             collapse = ","))
# write.csv(transactionData,"housing_transactions.csv", 
#           quote = FALSE, row.names = FALSE)
# tr <- read.transactions('housing_transactions.csv', 
#                         format = 'basket', sep=',')
# 
# if (!require("RColorBrewer")) {
#   # install color package of R
#   install.packages("RColorBrewer")
#   #include library RColorBrewer
#   library(RColorBrewer)
# }
# itemFrequencyPlot(tr,topN=20,type="absolute",
#                   col=brewer.pal(8,'Pastel2'), 
#                   main="Absolute Item Frequency Plot")
# 
# itemFrequencyPlot(tr,topN=20,type="relative",
#                   col=brewer.pal(8,'Pastel2'),
#                   main="Relative Item Frequency Plot")
# 
# association.rules <- apriori(tr, 
#                              parameter = list(supp=0.001, conf=0.8,maxlen=10))
# summary(association.rules)
# inspect(association.rules[1:10])
# frequentItems <- eclat (data$ocean_proximity, parameter = list(supp = 0.07, 
#                                                     maxlen = 15))
# inspect(frequentItems)

### ============ CLUSTERING ==============
min_max_norm <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
data_norm<- as.data.frame(lapply(data[2:12], min_max_norm))

set.seed(3141592) 
index <- sample(nrow(data_norm), round(0.75*nrow(data_norm)))
train <- data_norm[index,] 
test <- data_norm[-index,]
train_label<- data[index,1]
test_label<- data[-index,1]


#Clustering using kmeans

#Optimum number of clusters. Elbow method
# Alternative using fviz function for Elbow method
#set.seed(123)
fviz_nbclust(train, hcut, method = "wss", k.max = 20)
fviz_nbclust(train, hcut, method = "silhouette")
gap_stat <- clusGap(train, FUN = hcut, nstart = 25,
                    K.max = 15, B = 25)
print(gap_stat, method = "firstmax")

# Alternative using the fviz_gap_stat function
fviz_gap_stat(gap_stat)


#Clustering using HC
# computing distance matrix between the rows of the data matrix
distance <- dist(train,method = "euclidean")

# Visualization of a distance matrix
fviz_dist(distance, gradient = list(low = "#00AFBB", 
                                    mid = "white", high = "#FC4E07"))

# Hierarchical clustering using COMPLETE LINKAGE
hc_CL<-hclust(distance, method="complete")

# Plot the obtained dendrogram
plot(hc_CL, cex=0.6, hang=-1)

# similar estimation using agnes
hc_CL_agnes<-agnes(data, method = "complete")

#Agglomerative coefficient
hc_CL_agnes$ac

# Plot the obtained dendrogram
pltree(hc_CL_agnes, cex=0.6, hang=-1)

# Comparing different HC methods
# methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# function to compute coefficient
ac <- function(x) {
  agnes(train, method = x)$ac
}

map_dbl(m, ac)

#Using the ward method as identified in this case as better
hc_CL_Ward <- agnes(train, method = "ward")
pltree(hc_CL_Ward, cex = 0.6, hang = -1, main = "Dendrogram of agnes - Ward")


# Sub-Groups identification
# Ward's method
hc_sg <- hclust(distance, method = "ward.D2" )

# Cut tree into 7 groups
sub_grp <- cutree(hc_sg, k = 7)

# Number of members in each cluster
table(sub_grp)


######## Analysis of clusters
confusionMatrix(as.factor(train_label), as.factor(assoc$cluster))

#Plotting sub-groups with colors
plot(hc_sg, cex = 0.6)
rect.hclust(hc_sg, k = 7, border = 2:5)

fviz_cluster(list(data = train, cluster = sub_grp), 
             choose.vars = c("median_house_value", "total_rooms") )


           