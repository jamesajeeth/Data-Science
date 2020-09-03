#-----------------------------------------------------------------------------------------
#Name :  James Ajeeth J
#Roll No : E20013
#-----------------------------------------------------------------------------------------

#_______________________________________________________________________________________
#Chi square
#this function works well when the target is a categorical data type
#_______________________________________________________________________________________
setwd("C:\\Users\\Thanis\\Desktop\\Data Science\\Term 2\\R")
fram <- read.csv("framingham.csv")

chi_square2 <- function(data, y)
{
  ndata <- data[,c(y)]
  index <- match(y, names(data))
  names(ndata) <- colnames(data)[index]
  data[,c(y)] <- NULL
  new_df = c()
  rem = c()
  pval = c()
  j=1
  k=1
  for(i in 1:(ncol(data)))
  {
    #checking whether the particular feature is categorical or not and adding it to a diff dataframe
    if(length(unique(data[,i])) <= 5)
    {
      new_df[j] <- colnames(data)[i]
      j <- j+1
    }
    else
    {
      rem[k] <- colnames(data)[i]
      k <- k+1
    }
  }
  
  for(j in 1:(length(new_df)))
  {
    #print(paste((new_df[j]),' vs ',y, sep = ""))
    p_val = chisq.test(data[,new_df[j]],ndata, correct = FALSE)
    pval[j] = p_val$p.value
  }
  print(paste("Individual feature vs", y))
  names(pval) = names(data[,new_df])
  return(pval)
  
}

#pass the datafram and target variable in y
chi_square2(fram, y = "TenYearCHD")


#_______________________________________________________________________________________
#T_Test
#this function works well when the target is a categorical data type
#_______________________________________________________________________________________

#defining function
t_test2 <- function(data, y)
{
  #segregating the target varible from dataframe and adding it into a new dataframe
  ndata <- data[,c(y)]
  index <- match(y, names(data))
  names(ndata) <- colnames(data)[index]
  data[,c(y)] <- NULL
  new_df = c()
  rem = c()
  pval = c()
  j=1
  k=1
  for(i in 1:(ncol(data)))
  {
    #checking whether the particular feature is categorical or not and adding it to a diff dataframe
    if(length(unique(data[,i])) <= 5)
    {
      new_df[j] <- colnames(data)[i]
      j <- j+1
    }
    else
    {
      rem[k] <- colnames(data)[i]
      k <- k+1
    }
  }
  
  for(j in 1:(length(rem)))
  {
    #print(paste((rem[j]),' vs ',y, sep = ""))
    p_val = t.test(data[,rem[j]],ndata)
    pval[j] = p_val$p.value
  }
  print(paste("Individual feature vs", y))
  names(pval) = names(data[,rem])
  return(pval)
  
}

#pass the datafram and target variable in y 

t_test2(fram, y = "TenYearCHD")


#_______________________________________________________________________________________
#Segmentation
# This function will order the dataframe according to the data type.In orders of Interger
# numeric, character, factor,logical
#_______________________________________________________________________________________

newfn2 <- function(fram)
{
  int = c()
  num = c()
  cha = c()
  fac = c()
  logi = c()
  j=1
  k=1
  l=1
  m=1
  n=1
  for(i in 1:ncol(fram))
  {
    if(class(fram[,i]) == "integer")
    {
      int[j] <- colnames(fram)[i]
      j <- j+1
    }
    if(class(fram[,i]) == "numeric")
    {
      num[k] <- colnames(fram)[i]
      k <- k+1
    }
    if(class(fram[,i]) == "character")
    {
      cha[l] <- colnames(fram)[i]
      l <- l+1
    }
    if(class(fram[,i]) == "factor")
    {
      fac[m] <- colnames(fram)[i]
      m <- m+1
    }
    if(class(fram[,i]) == "logical")
    {
      logi[n] <- colnames(fram)[i]
      n <- n+1
    }
  }
  #f<-cbind(int,num,cha,fac,logi)
  return(cbind(fram[,int],fram[,num],fram[,cha],fram[,fac],fram[,logi]))
}

p = newfn2(fram)
View(p)
