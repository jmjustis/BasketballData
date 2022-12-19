#IST 687 Project
#Authors

#Objective:


##########################################################################
#Step 1: Import database of NBA data:

library(tidyverse)
library(ggplot2)

library(readr)
#exploring database

player_attributes_df <- read_csv('C:/Users/nicky/Desktop/IST 687/Project/draft_pick_analysis_data_set.csv')
view(player_attributes_df)
str(player_attributes_df)

#################
#Business Question
#How significant is the the first draft pick?

#################

#I have to decide what columns I will want to need and what columns I do not.Then, create new dataframe called df.  

df <- select(player_attributes_df,ID,FIRST_NAME,LAST_NAME,TEAM_NAME,SCHOOL,COUNTRY,POSITION,DRAFT_YEAR,DRAFT_NUMBER,PTS,AST,REB,ALL_STAR_APPEARANCES)
df


#next we will have to remove rows that show NA in the columns we need

na.omit(df$DRAFT_NUMBER)

#for points, assists and rebounds, we will turn them to zero if NA. Also for All star appearances.
df <- df %>% mutate(PTS = ifelse(is.na(PTS), 0, PTS))
df <- df %>% mutate(AST = ifelse(is.na(AST), 0, AST))
df <- df %>% mutate(REB = ifelse(is.na(REB), 0, REB))
df <- df %>% mutate(ALL_STAR_APPEARANCES = ifelse(is.na(ALL_STAR_APPEARANCES), 0, ALL_STAR_APPEARANCES))
view(df)

#next, we need to clean columns that have a value of "undrafted" or "none"

str(df)
df <-subset(df, DRAFT_NUMBER!="None" & DRAFT_NUMBER!="Undrafted")

view(df)


#need to turn some columns into numeric values such as draft number and draft year.
str(df)

df$DRAFT_NUMBER <- as.numeric(df$DRAFT_NUMBER)
df$DRAFT_YEAR <- as.numeric(df$DRAFT_YEAR)


str(df)

summary(df)
view(df)

#next, I want to create a binary column that either shows a 1 if there was an all star appearance, or 0 if there was no all star appearance. 

df$ALL_STAR <- ifelse(df$ALL_STAR_APPEARANCES>=1,"YES","NO")

view(df)

str(df)

#visualizations

myplot <- ggplot(df, aes(x=ALL_STAR, y=DRAFT_NUMBER)) + geom_point() 
myplot



#creating a column to calculate player with best stats by adding points, assists and rebounds

TOTAL_POINTS <- df$PTS+df$AST+df$REB
TOTAL_POINTS
df$TOTAL_POINTS <- c(TOTAL_POINTS)
str(df)

myplot2 <- ggplot(df, aes(x=DRAFT_NUMBER, y=TOTAL_POINTS)) + geom_point()
myplot2

myplot3 <- ggplot(df, aes(x=DRAFT_NUMBER, y=TOTAL_POINTS)) + geom_point() + geom_smooth(method=lm)
myplot3


#let's see if there is a relationship between total points and draft pick using linear regression
library(caret)

trainList <- createDataPartition(df$DRAFT_NUMBER,p=.7,list=FALSE)
trainData <- df[trainList,]
testData <- df[-trainList,]

dim(trainData)
dim(testData)

set.seed(123)

lm.model <- train(TOTAL_POINTS ~ DRAFT_NUMBER, data = trainData, trControl=trainControl(method='none'),method='lm')
summary(lm.model)

predictValues <- predict(lm.model, newdata=testData)
cor(predictValues,testData$TOTAL_POINTS)^2

#we see that R squared is low and so is the correlation

length(df$ALL_STAR[is.na(df$ALL_STAR)])

#Making it a factor
df$ALL_STAR <- as.factor(df$ALL_STAR)

#SVM model that shows if draft number is a good predictor of an all star appearance
#set.seed(123)
trainList2 <- createDataPartition(y=df$ALL_STAR,p=.70,list=FALSE)
trainData2 <- df[trainList2,]
testData2 <- df[-trainList2,]

dim(trainData2)
dim(testData2)

svm.model <- train(ALL_STAR ~ DRAFT_NUMBER + TOTAL_POINTS
                   , data=trainData2,method='svmRadial',trControl=trainControl(method='none'),
                   preProcess= c('center','scale'))
svm.model$finalModel
svmPred <- predict(svm.model, testData2, type='raw')
confusionMatrix(testData2$ALL_STAR,svmPred)




