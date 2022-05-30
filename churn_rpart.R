
library(C50)        # for obtaining data
library(tidyverse)  # for data processing
library(rpart)      # for CART decision tree
library(rpart.plot) # for plotting CART
library(caret)      # for confusion matrix and more


data<-read.csv('discografia.csv',sep=',',stringsAsFactors=T)
set.seed(3141592)
data$Track <- NULL
summary(data)
data<-na.omit(data)
datos_split<- initial_split(data, prop=0.8)
churnTrain<- training(datos_split)
churnTest<- testing(datos_split)

# Creating the decision tree algorithm in CART
tree_result<- rpart(formula=Album  ~ ., data=churnTrain, method='class')

#Resulting tree
print(tree_result)

# Alternative views
summary(tree_result)




#Fitting the plotting allowing labels in several lines
  split.fun <- function(x, labs, digits, varlen, faclen)
  {
    # replace commas with spaces (needed for strwrap)
    labs <- gsub(",", " ", labs)
    for(i in 1:length(labs)) {
      # split labs[i] into multiple lines
      labs[i] <- paste(strwrap(labs[i], width = 10), collapse = "\n")
    }
    labs
  }
  
#PLotting the tree
rpart.plot(tree_result, type=1, branch=0,tweak=2.3, 
             fallen.leaves = TRUE,
             varlen = 0, faclen = 0, split.fun=split.fun)
#Alternative for plotting the tree
prp(tree_result, faclen=3, clip.facs=TRUE, 
             split.fun=split.fun, tweak=1.2, extra=101)

################# #Prediction ############
#Poor option to plot the tree
plot(tree_result, uniform=TRUE, compress=TRUE)
text(tree_result, use.n=TRUE)

plot(tree_result, subtree=3)

#Obtainimng the decision rules from the tree
rpart.rules(tree_result, style = "tall", cover=TRUE,
            nn=TRUE, clip.facs = TRUE)
            

#Prediction of the training cases from the train dataset
pred_train <- predict(tree_result, newdata = churnTrain, type ="class")
confusionMatrix(pred_train, churnTrain$Album)

table(prediction=pred_train, real= churnTrain$Album)

error_classification <- mean(pred_train != churnTrain$Album)

paste("The classification error is:", 100*error_classification, "%",
      sum(pred_train==churnTrain$Album),
      "correct classified cases from", length(pred_train))

#Prediction of new cases from the test dataset
predictions <- predict(tree_result, newdata = churnTest, type ="class")
confusionMatrix(predictions, churnTest$Album)

table(prediction=predictions, real= churnTest$Album)

error_classification <- mean(predictions != churnTest$Album)

paste("The classification error is:", 100*error_classification, "%",
      sum(predictions==churnTest$Album),
      "correct classified cases from", length(predictions))



#Prunning analysis
tree_pruned<- prune(tree_result, cp=0.02)
rpart.plot(tree_pruned, type=1, branch=0,tweak=2.3, 
           fallen.leaves = TRUE,
           varlen = 0, faclen = 0, split.fun=split.fun)


#Prediction of the training cases from the train dataset PRUNING
pred_train <- predict(tree_pruned, newdata = churnTrain, type ="class")
confusionMatrix(pred_train, churnTrain$Album)

table(prediction=pred_train, real= churnTrain$Album)

error_classification <- mean(pred_train != churnTrain$Album)

paste("The classification error is:", 100*error_classification, "%",
      sum(pred_train==churnTrain$Album),
      "correct classified cases from", length(pred_train))

#Prediction of new cases from the test dataset
predictions <- predict(tree_pruned, newdata = churnTest, type ="class")
confusionMatrix(predictions, churnTest$Album)

table(prediction=predictions, real= churnTest$Album)

error_classification <- mean(predictions != churnTest$Album)

paste("The classification error is:", 100*error_classification, "%",
      sum(predictions==churnTest$Album),
      "correct classified cases from", length(predictions))



# Analysis of cp values in a table
printcp(tree_result, digits=4)


# Error evolution with increasing number of nodes
plotcp(tree_result, lty=2 , col="red", upper="size" )
plotcp(tree_result, lty=2 , col="red", upper="splits" )


#Prunning analysis with cp 0.035
tree_pruned<- prune(tree_result, cp=0.035)
rpart.plot(tree_pruned, type=1, branch=0,tweak=1.8, 
           fallen.leaves = TRUE,
           varlen = 0, faclen = 0, split.fun=split.fun)


#Prediction of the training cases from the train dataset PRUNING
pred_train <- predict(tree_pruned, newdata = churnTrain, type ="class")
confusionMatrix(pred_train, churnTrain$Album)

table(prediction=pred_train, real= churnTrain$Album)

error_classification <- mean(pred_train != churnTrain$Album)

paste("The classification error is:", 100*error_classification, "%",
      sum(pred_train==churnTrain$Album),
      "correct classified cases from", length(pred_train))

#Prediction of new cases from the test dataset
predictions <- predict(tree_pruned, newdata = churnTest, type ="class")
confusionMatrix(predictions, churnTest$Album)

table(prediction=predictions, real= churnTest$Album)

error_classification <- mean(predictions != churnTest$Album)

paste("The classification error is:", 100*error_classification, "%",
      sum(predictions==churnTest$Album),
      "correct classified cases from", length(predictions))





