



df.train <- read.csv('titanic_train.csv')
head(df.train)
library(Amelia)
missmap(df.train, main="Titanic Training Data - Missings Map", 
        col=c("yellow", "black"), legend=FALSE)
#missmap is use for checking the missing values in the train data.Roughly 20 percent of the Age data is missing.


#Data Visualization with ggplot2
library(ggplot2)
ggplot(df.train,aes(Survived)) + geom_bar()
ggplot(df.train,aes(Pclass)) + geom_bar(aes(fill=factor(Pclass)),alpha=0.5)
ggplot(df.train,aes(Sex)) + geom_bar(aes(fill=factor(Sex)),alpha=0.5)
ggplot(df.train,aes(SibSp)) + geom_bar(fill='red',alpha=0.5)
ggplot(df.train,aes(Fare)) + geom_histogram(fill='green',color='black',alpha=0.5)

#Data Cleaning
#   We want to fill in missing age data instead of just dropping the missing age data rows. 
#   One way to do this is by filling in the mean age of all the passengers (imputation).
ggplot(df.train,aes(Pclass,Age)) + geom_boxplot(aes(group=Pclass,fill=factor(Pclass),alpha=0.3)) + scale_y_continuous(breaks = seq(min(0), max(80), by = 2))

#  We can see the wealthier passengers in the higher classes tend to be older, which makes sense.
#  We'll use these average age values to impute based on Pclass for Age

impute_age <- function(age,class){
  out <- age
  for (i in 1:length(age)){
    
    if (is.na(age[i])){
      
      if (class[i] == 1){
        out[i] <- 37
        
      }else if (class[i] == 2){
        out[i] <- 29
        
      }else{
        out[i] <- 24
      }
    }else{
      out[i]<-age[i]
    }
  }
  return(out)
}


fixed.ages <- impute_age(df.train$Age,df.train$Pclass)
df.train$Age <- fixed.ages




missmap(df.train, main="Titanic Training Data - Missings Map", 
        col=c("yellow", "black"), legend=FALSE)

#Building a Logistic Regression Model
#Let's begin by doing a final "clean-up" of our data by removing the features we won't be using and making sure that the features are of the correct data type.
str(df.train)
head(df.train,3)

# selected the relevant columns for training
library(dplyr)
df.train <- df.train[,c(2,3,5,6,7,8,10,12)]
head(df.train,3)


#Now let's set factor columns
str(df.train)
df.train$Survived <- factor(df.train$Survived)
df.train$Pclass <- factor(df.train$Pclass)
df.train$Parch <- factor(df.train$Parch)
df.train$SibSp <- factor(df.train$SibSp)



#Train the Model
log.model <- glm(formula=Survived ~ . , family = binomial(link='logit'),data = df.train)
summary(log.model)


#Interpretation
#We can see clearly that Sex,Age, and Class are the most significant features. Which makes sense given the women and children first policy.
#The null deviance shows how well the response is predicted by the model with nothing but an intercept.
#The residual deviance shows how well the response is predicted by the model when the predictors are included. 

#We can also use the residual deviance to test whether the null hypothesis is true (i.e. Logistic regression model provides an adequate fit for the data).
#  This is possible because the deviance is given by the chi-squared value at a certain degrees of freedom. 
#  In order to test for significance, we can find out associated p-values using the below formula in R:
# 
#p-value = 1 - pchisq(deviance, degrees of freedom)
#Using the above values of residual deviance and DF, a p-value  showing that there is a significant  evidence to support the null hypothesis.

1 - pchisq(763.41, 870)


#prediction
library(caTools)
set.seed(101)

split = sample.split(df.train$Survived, SplitRatio = 0.70)

final.train = subset(df.train, split == TRUE)
final.test = subset(df.train, split == FALSE)
final.log.model <- glm(formula=Survived ~ . , family = binomial(link='logit'),data = final.train)
summary(final.log.model)
fitted.probabilities <- predict(final.log.model,newdata=final.test,type='response')
fitted.results <- ifelse(fitted.probabilities > 0.5,1,0)
misClasificError <- mean(fitted.results != final.test$Survived)
print(paste('Accuracy',1-misClasificError))

#Looks like we were able to achieve around 80% accuracy
table(final.test$Survived, fitted.probabilities > 0.5)



