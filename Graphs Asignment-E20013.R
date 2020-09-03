#-----------------------------------------------------------------------------------------
#Name :  James Ajeeth J
#Roll No : E20013
#-----------------------------------------------------------------------------------------
#suggestion 1
#Often we are not required the graphs for all the numeric variables. Try to improve the code
#by adding an additional parameter "variable" that can take a vector of variable index and 
#return the graphs for only those variables.
#
#Example: Graphs(Boston, var=c(1,3,4))
#Will generate the graphics for only the numerical variables among the variables 1,3 & 4
#in the data Boston

library(MASS)
data("Boston")
#View(Boston)
setwd("C:\\Users\\Thanis\\Desktop\\Data Science\\Term 2\\R")
cars <- read.csv("cars.csv")

Graphs <- function(data, var)
{
  if(!is.data.frame(data))
    stop("The given object is not a data frame")
  
  for(i in 1:ncol(data))
  {
    #check whether the individual column is numeric and present in the variable vector
    if(is.numeric(data[,i]) && i %in% var)
    {
      
      #png(paste(names(data)[i], ".png", sep="")) #NOTE this step
      
      par(mfrow=c(2,1))
      boxplot(data[,i], main = paste("Boxplot of", names(data)[i]), 
              ylab = names(data)[i], col = "maroon", border = "grey5",
              horizontal = T)
      
      hist(data[,i], main = paste("Histogram of", names(data)[i]), 
           xlab = names(data)[i], ylab = "No. of Houses", col = "lightgreen", border=F)
      
      
      
      #dev.off()  #NOTE this step
      
    }
    
  }
}


Graphs(Boston, c(5,6))

#suggestion 2
#Improve the code in suggestion 1 such that if the argument variable is ignored then it will
#return the graphs of all the numeric variables in the data by default.


#if the variables are not passed by default it prints the graph for the all the columns
Graphs <- function(data, var=1:ncol(data))
{
  if(!is.data.frame(data))
    stop("The given object is not a data frame")
  
  for(i in 1:ncol(data))
  {
    if(is.numeric(data[,i]) && i %in% var)
    {
      
      #png(paste(names(data)[i], ".png", sep="")) #NOTE this step
      
      par(mfrow=c(2,1))
      boxplot(data[,i], main = paste("Boxplot of", names(data)[i]), 
              ylab = names(data)[i], col = "maroon", border = "grey5",
              horizontal = T)
      
      hist(data[,i], main = paste("Histogram of", names(data)[i]), 
           xlab = names(data)[i], ylab = "No. of Houses", col = "lightgreen", border=F)
      
      
      
      #dev.off()  #NOTE this step
      
    }
    
  }
}

Graphs(Boston, c(5,6))
Graphs(cars, c(5,6))
Graphs(Boston)
#View(Boston)


#suggestion 3
#We ignored the cateorical variables in our discussion. Make some improvement in your codes
#in suggestion 2 such that the function will take the argument "data" and "variable" and will
#return boxplots & histograms for the numerical variables and barplots and pie charts for
#the categorical variables.
#
#Example:
#Graphs(mtcars)
#will get the necessary graphics for all numeric variables and categorical variables in the
#data

Graphs <- function(data, var=1:ncol(data))
{
  #to check whether dataframe passed inside a function is a dataframe and passed variable is within the range of the dataframe
  if(!is.data.frame(data) | ncol(data) < max(var))
    #print("inside")
    stop("The given object is not a data frame or mentioned column is out of range")
  
  for(i in 1:ncol(data))
  {
    if(is.numeric(data[,i]) && i %in% var)
    {
      #print("inside2")
      #png(paste(names(data)[i], ".png", sep="")) #NOTE this step
      
      par(mfrow=c(2,1))
      boxplot(data[,i], main = paste("Boxplot of", names(data)[i]), 
              ylab = names(data)[i], col = "maroon", border = "grey5",
              horizontal = T)
      
      hist(data[,i], main = paste("Histogram of", names(data)[i]), 
           xlab = names(data)[i], ylab = "Frequency", col = "lightgreen", border=F)
      
      
      
      #dev.off()  #NOTE this step
      
    }
    
    #if categorical vaiable is passed then the corressponding bar and pie chart are plotted
    else if(!is.numeric(data[,i]) && i %in% var)
    {
      #print("inside3")
      #png(paste(names(data)[i], ".png", sep=""))
      par(mfrow=c(1,2))
      barplot(table(data[,i]), main = paste("Bar Chart", names(data)[i]),
              col = rainbow(length(table(data[,i]))))
      pie(table(data[,i]), radius = 1, main = paste("Pie Chart", names(data)[i]), 
          col = rainbow(length(table(data[,i]))))
      
      #dev.off()
    }
    
  }
}



Graphs(cars, c(8,9))
View(cars)


#SUGGESTION 4:
#Probably you need not want to mess up your working directory with so many image files...
#Create an additional argument for the function "dir" (directory), such that the function
#exports all the files to your specified folder (which need not necessaryly be your working
#directory).
#
#Example:
#Graphs(Boston, Variable = c(1,3,4), dir = ".../Praxis/LearntSometingNew/Graphs")
#will generate the necessary graphics for the variables 1, 3 and 4 in the specified location
#in your system i.e. ".../Praxis/LearntSometingNew/Graphs"


Graphs <- function(data, var=1:ncol(data), dir= "C:\\Users\\Thanis\\Desktop\\Data Science\\Term 2\\R\\Images\\")
{
  #to check whether dataframe passed inside a function is a dataframe and passed variable is within the range of the dataframe
  if(!is.data.frame(data) | ncol(data) < max(var))
    #print("inside")
    stop("The given object is not a data frame or mentioned column is out of range")
  
  for(i in 1:ncol(data))
  {
    if(is.numeric(data[,i]) && i %in% var)
    {
      #print("inside2")
      png(paste(dir,names(data)[i], ".png", sep="")) #NOTE this step
      
      par(mfrow=c(2,1))
      boxplot(data[,i], main = paste("Boxplot of", names(data)[i]), 
              ylab = names(data)[i], col = "maroon", border = "grey5",
              horizontal = T)
      
      hist(data[,i], main = paste("Histogram of", names(data)[i]), 
           xlab = names(data)[i], ylab = "Frequency", col = "lightgreen", border=F)
      
      
      
      dev.off()  #NOTE this step
      
    }
    else if(!is.numeric(data[,i]) && i %in% var)
    {
      #print("inside3")
      png(paste(dir,names(data)[i], ".png", sep=""))
      par(mfrow=c(1,2))
      barplot(table(data[,i]), main = paste("Bar Chart", names(data)[i]),
              col = rainbow(length(table(data[,i]))))
      pie(table(data[,i]), radius = 1, main = paste("Pie Chart", names(data)[i]), 
          col = rainbow(length(table(data[,i]))))
      
      dev.off()
    }
    
  }
}


Graphs(cars, c(8,9))
