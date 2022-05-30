library(tidyverse)      #data manipulation and visualization
library(class)          # to call class package for kNN
library(caret)          # for building the model
library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization
library(dummies)  #for creration of dummy variables
library(caret)     #for confusion matrix
library(RSNNS)     #for normalization



data<-read.csv('discografia.csv',sep=',',stringsAsFactors=T)
datos<-read.csv('discografia.csv',sep=',',stringsAsFactors=T) 
set.seed(3141592) 
data$Track <- NULL
data$Album <- NULL
#index <- sample(nrow(data), round(0.1*nrow(data)))
#data <- data[index,] 
summary(data)
data<-na.omit(data)
min_max_norm <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
data_norm<- as.data.frame(lapply(data[1:11], min_max_norm))

#conversion to data frame
data.n<- as.data.frame(data_norm)

colnames(data.n)<- colnames(data)


#transposing the data matrix for getting distances of variables (products)
tdata<-t(data.n)

# data structure where all the varaibles are integers including 
#'Creditability' which is the response variable for this example.
str(data)

#removing any missing value
fviz_nbclust(data.n, kmeans, method = "wss", k.max = 20)

#Optimum number of clusters. Silhouette method
# function to compute average silhouette for k clusters
#set.seed(123)
fviz_nbclust(data.n, kmeans, method = "silhouette")

#GAP method
# compute gap statistic
#set.seed(123)
gap_stat <- clusGap(data.n, FUN = kmeans, nstart = 25,
                    K.max = 15, B = 25)
# Print the result
print(gap_stat, method = "firstmax")

# Alternative using the fviz_gap_stat function
fviz_gap_stat(gap_stat)



########## 5 clusters one per type of wine
cluster6<-kmeans(data.n,centers=9,nstart=20)

# clustering results
str(cluster6)
cluster6

cluster6$size

#visualization  of clusters 
fviz_cluster(cluster6, data=data.n,
             choose.vars = colnames(data.n[, c("Acousticness","Energy")]))



#denormalizing centers to obtain real values
codes<- cluster6$centers

denorm_codes<- denormalizeData(codes, getNormParameters(data_norm_or))

denorm_codes<-as.data.frame(denorm_codes)
names(denorm_codes) <- colnames(data.n)

denorm_codes


#################  Cluster assigmnement 

assigned_cluster <- cluster6$cluster

data.n$assigned_cluster<- cluster6$cluster

data$assigned_cluster<- cluster6$cluster
data.n$Album <- datos$Album

           