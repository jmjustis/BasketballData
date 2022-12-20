![final project cover](https://user-images.githubusercontent.com/119478875/208176028-08e50c39-a237-4bdd-9921-1bec020668e5.png)



# NBA Sports Analytics - A Managerial Approach
### IST 687 Final Project
*** 
## Table of Content
1. Introduction
2. Business Questions
3. Data Cleanse/ Munging/ Preparation
4. Descriptive Statistics/ Vizualizations
5. Data Modeling
6. Conclusions
7. Appendix - Code

***
## 1. Introduction

Our approach was to put ourselves in the shoes of a management team that is assigned to put together the best NBA team possible. Our team put together a set of fundamental business questions that will help us determine where the team can save in costs as well as where to look for talent. We believe that our managerial approach is significally a better and more scientific approach rather than blindly trying to put together a team. 

## 2. Business Questions
1. Is there a relationship between a player’s salary and player’s performance?
    * Which players are undervalued or overvalued?
    * How much should we pay a player based on their performance?

*(This business question helps our team determine budgeting costs. What is the most optimal salary to pay? Does a big salary improve performance?)*

2. How significant is the the first draft pick?
    *If you are a basketball team manager, is it worth it to spend extra money or trade players to be a first round pick?

*(This is another budget question that will help managers of teams see how important salaries are to performance.)*

3. What is the optimal geolocation to start a basketball team? What region has the best performing players?
    *Is there a specific birthplace that produces better basketball players?
    *Is there a specific college that produces better basketball players?
    
*(This final business question is to determine where to target the draft picks from)*

## 3. Data Cleanse/ Munging/ Preparation    

Our team used a free data set from kaggle: https://www.kaggle.com/datasets/wyattowalsh/basketball. Which had an enormous amount of data from basketball games to player statistics. The database was in sqllite format given by kaggle so our team had to use an sql query via Jupyter notebooks in order to pull only the data that we needed. Each business question had its own dataset taken from the database. We extracted the dataset via sql and exported into csv format. From there, we would upload the csv into R to do our data cleansing. 

Exibit 3.1) *This query was used to pull just the "player attributes" dataset from the database.*

![sample query](https://user-images.githubusercontent.com/119478875/208268033-eca28f39-73bd-479b-964b-f5bf904e9c83.png)

### Data preparation for business question 1: Salary vs. Player Performance

In our data set the salary for players and the performance were located in two different tables.  The salary was listed for each contract, which meant in the salary table each player had multiple rows.  The first step to getting the data set ready was to group the contracts by the players name and get both the sum and average contract for each player in the salary table.

 ![Picture1](https://user-images.githubusercontent.com/80026659/208272688-3c842eec-723e-4c28-99b3-5d354dda0c40.png)

After getting the salary dataset grouped by player with both sum and average contract, we could combine in with the table containing player performance statistics.
![Picture10](https://user-images.githubusercontent.com/80026659/208272762-04d0b7ee-fe60-43ea-8ae9-dbb6d63049fa.png)


After merging the datasets we were left with 415 players that had both player performance statistics as well as salary data.  We then added the statistics Points, Rebounds, and Assists into one variable called PRA.
![Picture2](https://user-images.githubusercontent.com/80026659/208272691-31bc6d90-c9ee-47a0-84a4-4cc79ebc0bc4.png)

### Data preparation for business question 2: First Draft Pick

* After the csv was read using read_csv(), we inspected the columns available to us and created a dataframe with the only columns we needed:

df <- select(player_attributes_df,ID,FIRST_NAME,LAST_NAME,TEAM_NAME,SCHOOL,COUNTRY,POSITION,DRAFT_YEAR,DRAFT_NUMBER,PTS,AST,REB,ALL_STAR_APPEARANCES)

* Next, we removed rows that show NA in the columns we selected in df.

na.omit(df$DRAFT_NUMBER)

* For points, assists and rebounds, we turned all NA's to zeros. We also did the same for All Star Appearances - the logic being, there was most likely no All Star Appreance if there is an NA.

df <- df %>% mutate(PTS = ifelse(is.na(PTS), 0, PTS))
df <- df %>% mutate(AST = ifelse(is.na(AST), 0, AST))
df <- df %>% mutate(REB = ifelse(is.na(REB), 0, REB))
df <- df %>% mutate(ALL_STAR_APPEARANCES = ifelse(is.na(ALL_STAR_APPEARANCES), 0, ALL_STAR_APPEARANCES))

* Some columns also had values other than NA that needed to be removed too. Values that say "none" or "undrafted" were removed since those players did not end up getting drafted.

df <-subset(df, DRAFT_NUMBER!="None" & DRAFT_NUMBER!="Undrafted")

* We noticed that some columns needed to be numeric values such as draft number and draft year. So we made those changes: 

df$DRAFT_NUMBER <- as.numeric(df$DRAFT_NUMBER)
df$DRAFT_YEAR <- as.numeric(df$DRAFT_YEAR)

* Now, some additional columns needed to be created. We wanted to create a binary column that either shows if someone had an All Star Appearance or not. The logic being that some players had many All Star Appearances and we did not want to scew the data too much. 

df$ALL_STAR <- ifelse(df$ALL_STAR_APPEARANCES>=1,"YES","NO")

* Finally, the last column we created was a way to combine all the possible points a player can earn into one number. We did this simply by adding all the points a player can earn by points, assits and rebounds. 

TOTAL_POINTS <- df$PTS+df$AST+df$REB
TOTAL_POINTS
df$TOTAL_POINTS <- c(TOTAL_POINTS)

### Data preparation for business question 3: Optimal Geolocation
Extracted the columns i needed from the SQL file and downloading it and importing it as a cvs file using the read_csv() function.
assigned the the file to the df variable.

df <- df[,-1]  Used this code to get rid of the unnecessary indexes and then procceded to check for NA's using the length(df$var[is.na(df$var)] to
check for NA's across the variables.

Then procceded to eliminate them accordingly, for numeric variables like PTS, AST. REB and ALL_STAR_APPEARANCES all NA's were replaced with zeros using:
df$PTS[is.na(df$PTS)] <- 0
df$AST[is.na(df$AST)] <- 0
df$REB[is.na(df$REB)] <- 0
df$ALL_STAR_APPEARANCES[is.na(df$ALL_STAR_APPEARANCES)] <- 0

Then separated the dataframe into US players and international players using the filter function from tidyverse

df %>% filter(COUNTRY == 'USA') -> USdf

#International players 
df %>% filter(COUNTRY != 'USA') -> INTdf

With this now I was able to work with the data for selecting the top schools and with the international players date to see which country tends to have
the most productive players in terms of points, assists and rebounds.

For the Maps preparation it was particularly challenging because i had to extract the coordinates from the schools,and since the amount of schools was too great it was necessary to further organize the data using the group_by() function in combination with summarize to see where the top schools are in terms of both all star players
and amount of nba players developed overall.

Created a separate vector variable concatenating the top schools locations and with the "https://nominatim.openstreetmap.org/search/" i was able to create
two functions that would allow me to extract the latitude and longitude coordinates given the school name and state. It would do that with the paste0() function
where it would grab this link and paste the school adresss and then return as.numeric() both latitude and longitude using JsonLite within the function in which
all the code is included in the appendix. 

Once the coordinates have been extracted, I used data.frame() to join the latitude, longitude and location to the filtered dataframe and from there proceded to make the mapping with ggmaps and ggplot().  
## 4. Descriptive Statistics & Visualizations

### Statistics & Visualizations for Business Question 1: Salary vs. Player Performance


### Scatter Plots
This scatter plot compares total production (Points + Rebounds + Assists) with career earnings of each player in the dataset.  There is a large grouping of players with very low career earnings which is likely due to a large proportion of players only receiving one or two contracts in their careers as well as younger players that are still on of their first contracts even if that contract is large their career earnings are smaller compared to more experienced players.  

![Picture3](https://user-images.githubusercontent.com/80026659/208272695-3a6d3d17-69bc-4c48-9996-57d03107c972.png)

This scatter plot compares total production with average contract (not average per year as the data set did not provide lengths on contracts).  When comparing performance with average salary rather than total salary, the data is spread more evenly and appears to have a stronger linear relationship.

![Picture4](https://user-images.githubusercontent.com/80026659/208272697-567af282-91dd-48b5-9347-f90ac00dbe44.png)

### Column Charts
This column chart compares years of experience with total career earnings for each player in the dataset.

![Picture5](https://user-images.githubusercontent.com/80026659/208272772-b18f26bd-4ee4-4fe6-b511-ae9448069b8c.png)

This column chart compares years of experience with average career earnings for each player in the dataset.

![Picture6](https://user-images.githubusercontent.com/80026659/208272776-97f92661-9b2f-4339-9895-cf97e974f7c8.png)

This column chart compares our performance statistic PRA with total years of expereince for each player in the dataset.

![Picture7](https://user-images.githubusercontent.com/80026659/208272778-252fd06a-d3b3-4e0c-b231-9978575384f9.png)

From these datasets we can see that actually players with a medium level of experience (3-8) years seem to have the largest salaries both total and average contract and players with the most experience have the lowest total and average salaries.  Based on the chart showing performance and experience younger players in this dataset have much higher production than older players.  We would have suspected that more older players would have higher total career earnings but since our data set only has salary information for 415 players out of the 4500 total players in the set, it Is likely that these observations are not reflective of the whole.

### Bar Charts
These two bar charts compare the players who have the highest salaries in the NBA and the players who have high PRA statistics. The values we used to measure high salary and high PRA are $100,000,000 and 40. 

Here is the bar chart for players with a salary over $100,000,000. 

![Big Salary Order](https://user-images.githubusercontent.com/118240779/208514529-b243826e-67b6-4ef0-a06e-0b273c818f73.png)

Here is the bar chart for players with a PRA over 40. 

![HIGH PRA Order](https://user-images.githubusercontent.com/118240779/208514475-78c51468-9134-43d1-8484-87d185858707.png)

From these datasets, we can see that a few player names can be found on both the salary and PRA charts. We can see how high they are on each of the lists as well. Based on these charts, we can see that a few players, or 6 to be exact, reach both of these requirements. However, there are several players who only appear on one but not the other. Using this visual model, we can see there is a possible relationship between players who make a lot of money and players who perform very well on the court. However, it is not a 100% accurate correlation. 


### Statistics & Visualizations for Business Question 2: First Draft Pick

After the data was cleaned for business question 2, we decided to run some ggplots to get a better understanding. 

* First Draft Pick vs. All Star Appearance Scatter Plot:
![Draft pick vs  All star appearance](https://user-images.githubusercontent.com/119478875/208358179-88208cbe-58ea-42bb-8f69-34fdbb5c42a8.png)

*We can see visually that there does not seem to be much difference in being a draft pick vs. having all star appearances*

* First Draft Pick vs. Total Points

![Total Points vs Draft Number](https://user-images.githubusercontent.com/119478875/208358418-4e1963fe-bb88-4266-bacf-bfa6561616d7.png)

*The data here looks a bit scattered but in the next exhibit, we will see how the data looks around a line of best fit.*


* How dispearsed is the data around a line of best fit?

![Total Points vs Draft Number with LM](https://user-images.githubusercontent.com/119478875/208358432-74de105e-38ec-45b4-a261-aa2f5df9a886.png)

*As suspected, the line of best fit does not look good here with data dispearsed all over.*

### Statistics & Visualizations for Business Question 3: Optimal Geolocation
### Bar Chart
Here we take a look at which schools were the best at developing NBA caliber players.
![Top schools for amount of NBA players produced bar chart ](https://user-images.githubusercontent.com/119911893/208447962-8df97f6c-64c9-4f5d-b37e-2656fbce77ff.png)
### Visualizing it with maps
By creating functions within R that takes the school name and location from the streetmaps.org website with the vector I created to be able to return Latitudes and longitudes of each school that I put inside the argument or parameter of the function and adding those coordinates to our dataframe to visualize the location with maps.

![Top schools by total amount of NBA players produced map](https://user-images.githubusercontent.com/119911893/208447651-841a5594-0aea-47f0-a6eb-60724b54b6f0.png)
Here we further filter schools by amount of players that had at least one all star appearance
![Top schools by total amount of All stars bar chart](https://user-images.githubusercontent.com/119911893/208449763-08cd840d-2e00-406f-a97b-f2a880974aa3.png)
Mapping those results you can see that not suprisingly most of the schools who developed the most amount of NBA players also developed the most all stars
![Top schools by historical amount of all star players map](https://user-images.githubusercontent.com/119911893/208446975-6623fed0-6a78-4c09-a6d2-36adc07b50d0.png)
### Bar Chart for International countries based by players performance
 On this bar chart we take a look at which international countries were the most successful at developing players into the NBA based on the formula
 (PTS + 2*AST + 1.5 *Reb)
![Top international countries by players perfomance](https://user-images.githubusercontent.com/119911893/208448814-d9eff148-62b7-4323-9882-4ac11dfc3c98.png)

In conclusion you can see by the addition of maps that a great majority of the top schools in both metrics are located in the mid west region of the US. And you can see that not surprisingly the top schools include big names like UCLA, Kentucky and Duke.

## 5. Data Modeling

### Data Modeling for Business Question 1: Salary vs. Player Performance
* Linear Models
For the salary dataset we did two linear models with both total salary and average salary vs our performance statistic, PRA.  
![Picture8](https://user-images.githubusercontent.com/80026659/208272780-f04181cc-5448-4bb1-8aaf-b854566bd498.png)
![Picture9](https://user-images.githubusercontent.com/80026659/208272782-2ba9a953-4c9d-413f-b449-29c4451d49bb.png)

The first linear model for total salary has an adjusted R squared value of .53 which means that approximately 53% of the variance in total salary is explained by our performance statistic.  Average salary has a higher adjusted R squared with 62% of the variance in average salary being explained by the performance statistic.

* SVM Model
Our team wanted to create a SVM that will predict if someone with a high PRA will get a higher salary. So, we must create a binary factor to use. 

![SVM model 2](https://user-images.githubusercontent.com/118240779/208517194-5015763a-88d7-44bb-a79b-96d09c5f143c.jpg)

Then we will create two datasets to train and test our prediction. After that, we will use the caret package to build the SVM and predict if PRA will affect salary

![SVM model 3](https://user-images.githubusercontent.com/118240779/208517422-d2523d61-62cc-4c4a-bcb6-f106a7f5eb1d.jpg)

Finally, we will use the prediction function we just made to validate the model against our test data and use the confusion matrix to inspect the accuracy of this prediction. 

![SVM model 4](https://user-images.githubusercontent.com/118240779/208522034-88353eb2-d4cc-449f-b70a-c35e7905c346.jpg)


We see that 91% of the predicted samples were accurate and the no information rate is at 67%. The information rate is lower than the accuracy rate in the confusion matrix, indicating this is a strong prediction model. The p-value is also very low, supporting our model's integrity. 


### Data Modeling for Business Question 2: First Draft Pick

Our team wanted to run two types of models on first draft picks. One of which was the linear regression approach which would be useful to find out if the amount of points a player earned had any effect due to the fact that they were a first round draft pick.

The second model was the Support Vector Machine that would be able to see if there was a way to predict whether being a first round pick had a higher chance of earning an All Star Appearance. 

* Linear Model 
![LM model](https://user-images.githubusercontent.com/119478875/208361882-4a2e3386-333e-45c5-b62f-117fa13112ea.png)

We set up our model and trained it using 70% of the data set. We then saw how well of a predictive model this was down below:


![Linear Model Outcome 1](https://user-images.githubusercontent.com/119478875/208361806-2cb68f76-64aa-49a1-ac20-c5cc21afca2f.png)

![Linear Model Outcome 1 correlation value](https://user-images.githubusercontent.com/119478875/208362341-37ec2d3b-2494-4dfc-997b-d771a7425265.png)

Our results show us an R squared of just .15 and a correlation from the predictive values of only .17. This shows us that there is not much correlation between being the first draft pick vs. performance.

We can use this model to answer part of our business question and see which players are over or undervalued and how much we should pay each player.  Based on the second model which is using average contract amount we get an intercept of -3,690,576 and a coeffecient of 813,696 for our peformance statistic.  We can interpret this to mean that a player needs to average at least 4.5 PRA and then each additional point rebound or assist above that is worth $813,696 of additional contract value.  

So we would expect a player that averaged 10 points, 5 assists, and 5 rebounds per game (20 PRA) to have a contract valued at $12,583,344.  To maximize the value and performance of our team we would want to sign a player with those statistics to a contract of 12 million or less.  This can also help when having to give players new contracts deciding what an equitable value is based on their performance.

* SVM Model

![SVM model code](https://user-images.githubusercontent.com/119478875/208362908-bd33306f-f0be-40e2-a18c-89af2013b662.png)




Finally, the SVM model also showed similar results to the previous model. 

![SVM model](https://user-images.githubusercontent.com/119478875/208362929-833fede4-716a-406f-b715-e89e73f96d40.png)



While the model shows to have great predictive power, the big point here is that the no information rate is as good as our model. That means that anyone's best guess would do just as good as our model. 

![SVM model confusion matrix](https://user-images.githubusercontent.com/119478875/208362955-23cef2be-7dd9-498c-b203-5d822046c0d0.png)


## 6.Conclusions

Our team would like to first point out that we utilized a free dataset and we believe that our findings could reveal a lot more if we were able to utilize a paid dataset. However, with the free data available, we were able to pull useful insights for basketball managers or scouts. The first business question about player vs. salary shows that if considering performance to be derived from PRA points, then the majority of the talent pool lies in the average salary range. This is big because it shows that a manager does not need to pay top dollar for a top performer.

Furthermore, for business question 2, we show that a first draft pick does not necessarily correlate with great performance. This goes against all logic since typically fans and teams will rely on the draft pick process to speculate how well their team will perform. However, our data shows otherwise and we speculate that this is because managers and scouts could be attracted to players because of "fear of missing out" or focusing too much on "trending players". Whatever the case may be, it would not unreasonable to state that there is a lot of hubris in the basketball industry when it comes to managing teams.

Finally, our last business question shows exactly which schools should be targetted when recruiting players. Statistically, we see a strong correlation of which schools produce the best players. Further analysis can even be done with more data on why these schools produce the best players. 


## 7. Apendix

Each block of code is also found on this github in each individual folder. Down below is the combination of all the code run in R. 

1. Business Question 1:
library(tidyverse)

salaryDataset <- read_csv("C:\\Users\\mistr\\Downloads\\Player_Salary.csv")

view(salaryDataset)

salary = salaryDataset %>% group_by(namePlayer)
salary <- salary %>% summarise(value = sum(value))
avgSalary = salaryDataset %>% group_by(namePlayer)
avgSalary <- avgSalary %>% summarise(value = mean(value))

view(salary)

playerDataset <- read_csv("C:\\Users\\mistr\\Downloads\\Player_Attributes2.csv")

colnames(playerDataset)[2] = "namePlayer"

view(playerDataset)

statsSalary <- merge(salary, playerDataset, by = "namePlayer")
statsSalary <- merge(statsSalary, avgSalary, by = "namePlayer")

statsSalary$PRA <- statsSalary$PTS + statsSalary$AST + statsSalary$REB
colnames(statsSalary)[2] = "salary"
colnames(statsSalary)[10] = "avgSalary"

ggplot(statsSalary, aes(x = salary, y = PRA)) + geom_point() + ggtitle("Points + Rebounds + Assists vs Total Salary")

ggplot(statsSalary, aes(x = avgSalary, y = PRA)) + geom_point() + ggtitle("Points + Rebounds + Assists vs Average Salary")

---
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
#this is the coding done to retrieve and view the dataset Player_Salary

library(tidyverse)
salaryDataset <- read_csv("C:\\Users\\madelyn\\Downloads\\Player_Salary.csv")
view(salaryDataset)

#this is the coding done to isolate salaryDataset so it just lists players and their salary aka value

salary = salaryDataset %>% group_by(namePlayer)
salary <- salary %>% summarise(value = sum(value))

view(salary)

#this is the coding done to retrieve and view the dataset Player_Attributes2

playerDataset <- read_csv("C:\\Users\\madelyn\\Downloads\\Player_Attributes2.csv")

colnames(playerDataset)[2] = "namePlayer"

view(playerDataset)

#this is the coding done to merge the salary table with the playerDataset table, according to the players name

statsSalary <- merge(salary, playerDataset, by = "namePlayer")

str(statsSalary)
view(statsSalary)

#this also shows me that there are no missing values in statsSalary
summary(statsSalary$value)

#this is me changing the column name in statsSalary from "value" to "salary"
colnames(statsSalary)
colnames(statsSalary)[2] = "salary"

#here I am narrowing down the statsSalary table by creating a new subset of salaries that are over 100,000,000 and labeling it BigSalary
BigSalary <- subset(statsSalary, statsSalary$salary > 100000000)

#here I am seeing how many salaries are in this new group 
str(BigSalary)
summary(BigSalary)


#Here I have made a bar chart of the NBA Players who are a part of the "Big Salary" and I have ordered it from highest salary, to lowest salary
library(ggplot2)
library(forcats)

ggplot(data=BigSalary, aes(x=fct_reorder(namePlayer, salary), y=salary)) + geom_col() + coord_flip()+ ggtitle("Names of NBA Players with the Biggest Salary")


#Here I am adding the values from PTS, REB, and AST for each player to get their PRA statistic, this is now going to be a new column in the statsSalary dataframe

statsSalary$PRA <- statsSalary$PTS + statsSalary$AST + statsSalary$REB

view(statsSalary)

#Here I am seeing what the min, median, and max PRA are in this dataset
summary(statsSalary$PRA)

#here I am creating a subset table from statsSalary with the NBA players who have a PRA stat higher than 40
HighPRA<- subset(statsSalary, statsSalary$PRA > 40)
str(HighPRA)
summary(HighPRA)


#Here I have made a bar chart of the NBA Players who have a PRA higher than 40
library(ggplot2)
library(forcats)

ggplot(data=HighPRA, aes(x=fct_reorder(namePlayer, PRA), y=PRA)) + geom_col() + coord_flip() + ggtitle("Names of NBA Players with the Highest PRA")


#creating SVM that will predict if someone with a high PRA will get a higher salary
#creating a new dataframe called salaryPRA that has salary, position and PRA

library(readr)
library(tidyverse)

salaryPRA<- statsSalary[,c(2,4,9)]

str(salaryPRA)
summary(salaryPRA)

#making a new category where the PRA is binary so PRA greater than 16 equals 1 and everything else is equal to 0. The PRA mean is 15.59 

salaryPRA$Category <- ifelse(salaryPRA$PRA>16, "1","0")
salaryPRA
view(salaryPRA)

#setting the outcome we are trying to predict

salaryPRA1 <- data.frame( salary = salaryPRA$salary, 
                          position = salaryPRA$POSITION ,
                          PRA = salaryPRA$PRA, 
                          category = as.factor(salaryPRA$Category))
                          
str(salaryPRA1)


#creating 2 datasets, one for training and one for testing
install.packages("caret")
library(caret)

trainsalaryPRA <- createDataPartition(y=salaryPRA$Category, p=.70, list=FALSE)
trainsetsalaryPRA <- salaryPRA1[trainsalaryPRA, ]
testsetsalaryPRA <- salaryPRA1[-trainsalaryPRA, ]


dim(trainsetsalaryPRA)

dim(testsetsalaryPRA)

#using caret package to build svm to predict PRA

svm.model <- train(category~ ., 
                  data = trainsetsalaryPRA, 
                   method = "svmRadial", 
                   trControl=trainControl(method= "none"),
                   preProcess = c("center", "scale"))

svm.model

#output model 

svm.model$finalModel


#using predict function to validate the model against test data

svmPred <- predict(svm.model, testsetsalaryPRA, type= "raw")

head(svmPred)

#calculate confusion matrix using table function

compare <- data.frame(testsetsalaryPRA$category, svmPred)
table(testsetsalaryPRA$category, svmPred)

x <- table(testsetsalaryPRA$category, svmPred)
accuracy <- c(x[1,1] + x[2,2])/sum(x)
accuracy

#The accuracy in the confusion matrix is the amount of correctly predicted samples, divided by the total amount of salmes. This suggests 90% of the predicted samples were accurate. 

#comparing calculations with the confusionMatrix function from the caret package

confusionMatrix(testsetsalaryPRA$category, svmPred)

#encoding the target feature as factor
library(rpart)
library(e1071)
library(rpart.plot)

model <- rpart(category ~ ., data = trainsetsalaryPRA, method= "class")

rpart.plot(model)

pred_rpart <- predict(model, newdata= testsetsalaryPRA, type = "class")
confusionMatrix(testsetsalaryPRA$category, pred_rpart)


Business Question 2:

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

Business Question 3:

library(readr)
library(sqldf)
library(RSQLite)
library(tidyverse)


df <- read_csv('C:/Users/ijo28/Downloads/nba_players.csv')




library(tidyverse)
df <- df[,-1] #Getting rid of the indexes

#Checking for NA's in my attributes

length(df$DISPLAY_FIRST_LAST[is.na(df$DISPLAY_FIRST_LAST)])
length(df$DRAFT_YEAR[is.na(df$DRAFT_YEAR)])
length(df$SCHOOL[is.na(df$SCHOOL)])
length(df$COUNTRY[is.na(df$COUNTRY)])
length(df$PTS[is.na(df$PTS)])
length(df$AST[is.na(df$AST)])
length(df$REB[is.na(df$REB)])
length(df$ALL_STAR_APPEARANCES[is.na(df$ALL_STAR_APPEARANCES)])

#Filtering and substituting NAs
df %>% filter(!is.na(SCHOOL)) -> df

df$PTS[is.na(df$PTS)] <- 0
df$AST[is.na(df$AST)] <- 0
df$REB[is.na(df$REB)] <- 0
df$ALL_STAR_APPEARANCES[is.na(df$ALL_STAR_APPEARANCES)] <- 0

#Getting data for US Players
df %>% filter(COUNTRY == 'USA') -> USdf

#International players 
df %>% filter(COUNTRY != 'USA') -> INTdf



library(dplyr)


USdf %>% group_by(SCHOOL) %>% summarise(length(DISPLAY_FIRST_LAST)) -> School

#Renaming the grouped column

colnames(School)[which(names(School) == "length(DISPLAY_FIRST_LAST)")] <- "total_nba_players"

#Arranging the df in descending order of total players
School %>% arrange(desc(total_nba_players)) -> School


#Filtering by the top 15 schools

School %>% slice(1:15) -> top15Schools

Top15SchoolsDesc <- top15Schools
#Ordering the data in descending order for plotting
Top15SchoolsDesc$SCHOOL <- factor(Top15SchoolsDesc$SCHOOL, levels =
                                    Top15SchoolsDesc$SCHOOL[order(
                                      Top15SchoolsDesc$total_nba_players,
                                      decreasing = TRUE)])
#Generating the bar graph
ggplot(Top15SchoolsDesc) + aes(x=SCHOOL, y = total_nba_players) + 
  geom_bar(stat="identity", colour = "black", fill = "lightblue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Total nba players by school") + xlab("School") +
  ylab("Players amount")

#School location vector

Location <- c("University of Kentucky"," University of California Los Angeles, CA 90095",
              "North Carolina Chapel hill, NC"," Duke Durham, NC",
              " Kansas University Lawrence, KS","Indiana University Bloomington, IN", 
              "Notre Dame, IN","University of Arizona, AZ",
              "University of Louisville, KY","University of Michigan, Ann Arbor, MI",
              "Michigan State university, MI","Syracuse University, NY",
              "Villanova university, PA","St John's university , NY","Ohio State University, OH")

#Adding the location to the Schools
top15SchoolsWithLoc <- data.frame(top15Schools,Location)

#Created two functions to get coordinates


#Separating the function into Getting latitudes and longitudes individually
getLatitude <- function(address) {
  library(jsonlite)
  library(stringr)
  #%20 is the code to indicate blank spaces in the url we want to use
  address <- str_replace_all(address, " ", "%20")
  
  #define the url to get the geocode
  
  urlOfGEOCode <- paste0('https://nominatim.openstreetmap.org/search/',
                         address,'?format=json&addressdetails=0&limit=1')
  
  #Get the location data in Json format
  
  df1 <- jsonlite::fromJSON(urlOfGEOCode)
  
  #Get long or lat from df 
  
  latitude = as.numeric(df1$lat)
  
  return(latitude)
}


getLongitude <- function(address) {
  library(jsonlite)
  library(stringr)
  
  address <- str_replace_all(address, " ", "%20")
  
  #define the url to get the geocode
  
  urlOfGEOCode <- paste0('https://nominatim.openstreetmap.org/search/',
                         address,'?format=json&addressdetails=0&limit=1')
  
  #Get the location data in Json format
  
  df1 <- jsonlite::fromJSON(urlOfGEOCode)
  longitude = as.numeric(df1$lon)

  return(longitude)
  
}
#Getting Latidudes and Longitudes vectors with the functions created from the previous lines

schoolLatitudes <- c(getLatitude("University of Kentucky"),
                     getLatitude("University of California, Los Angeles, CA"),
                     getLatitude("North Carolina Chapel hill, NC"),
                     getLatitude("Duke Durham, NC"),
                     getLatitude("Kansas University Lawrence, KS"),
                     getLatitude("Indiana University Bloomington, IN"),
                     getLatitude("Notre Dame, IN"),
                     getLatitude("University of Arizona, AZ"),
                     getLatitude("University of Louisville, KY"),
                     getLatitude("University of Michigan, Ann Arbor, MI"),
                     getLatitude("Michigan State university, MI"),
                     getLatitude("Syracuse University, NY"),
                     getLatitude("Villanova university, PA"),
                     getLatitude("St John's university, NY"),
                     getLatitude("Ohio State University, OH"))

schoolLongitudes <- c(getLongitude("University of Kentucky"),
                      getLongitude("University of California, Los Angeles, CA"),
                      getLongitude("North Carolina Chapel hill, NC"),
                      getLongitude("Duke Durham, NC"),
                      getLongitude("Kansas University Lawrence, KS"),
                      getLongitude("Indiana University Bloomington, IN"),
                      getLongitude("Notre Dame, IN"),
                      getLongitude("University of Arizona, AZ"),
                      getLongitude("University of Louisville, KY"),
                      getLongitude("University of Michigan, Ann Arbor, MI"),
                      getLongitude("Michigan State university, MI"),
                      getLongitude("Syracuse University, NY"),
                      getLongitude("Villanova university, PA"),
                      getLongitude("St John's university, NY"),
                      getLongitude("Ohio State University, OH"))

#Adding the vectors to our data
top15SchoolsWithLoc <- data.frame(top15SchoolsWithLoc,schoolLatitudes,schoolLongitudes)


#Creating the base map
library(ggmap)
library(maps)
US <- map_data("state")
map.simple <- ggplot(US)

myBaseMap <- map.simple + geom_polygon(color='black', fill = 'wheat1',
                                       aes(x=long, y = lat, group = group)) + coord_map()


#Using ggplot with geom_point to add it to our map based on the school locations that were extracted.  

myBaseMap + geom_point(data = top15SchoolsWithLoc,
                       aes(x = schoolLongitudes, y = schoolLatitudes,
                           color = total_nba_players), 
                       size = 1.5) +
  scale_color_continuous(trans = 'reverse') + ggtitle("Top US schools location map") +
  geom_text(data = top15SchoolsWithLoc, aes(x = schoolLongitudes, y = schoolLatitudes, 
                label = SCHOOL, hjust=0, vjust=0, size = 1),size = 1.5) +
  theme(plot.title = element_text(hjust = 0.5))
  
  
  #Filter the data sets for players with at least 1 all star appearance
USdf %>% filter(ALL_STAR_APPEARANCES > 0) -> US_allStars

US_allStars %>% mutate(All_star = 1) -> US_allStars

#Grouping by School

US_allStars %>% group_by(SCHOOL) %>% summarise(sum(All_star)) -> schoolStars

colnames(schoolStars)[which(names(schoolStars) ==
                              "sum(All_star)")] <- "allStar_players"

#Rearranging columns

schoolStars %>% arrange(desc(allStar_players)) -> schoolStars

#Selecting the top 14 schools with most all star players

schoolStars %>% slice(1:14) -> schoolStars

#Generating the graph

schoolStarsDesc <- schoolStars
#Ordering the data in descending order for plotting
schoolStarsDesc$SCHOOL <- factor(schoolStarsDesc$SCHOOL, levels =
                                    schoolStarsDesc$SCHOOL[order(
                                      schoolStarsDesc$allStar_players,
                                      decreasing = TRUE)])
#Generating the bar graph
ggplot(schoolStarsDesc) + aes(x=SCHOOL, y = allStar_players) + 
  geom_bar(stat="identity", colour = "black", fill = "aquamarine1") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Top 14 schools by number of all star players") + xlab("School") +
  ylab("Total all stars")



#School addresses

allStarSchools <- c("University of California Los Angeles, CA 90095",
                    "North Carolina Chapel hill, NC","University of Michigan, Ann Arbor, MI",
                    "University of Kentucky","Duke Durham, NC", 
                    "Illinois State University, IL","Indiana University Bloomington, IN",
                    "Kansas University Lawrence, KS","St John's university, NY",
                    "California State Fullerton, CA", "University of Louisville, KY",
                    "Michigan state university, MI","Notre Dame, IN", "Ohio State University, OH"
                    
                    )

schoolLats <- c(getLatitude("University of california, Los Angeles, CA"),
                     getLatitude("North Carolina Chapel hill, NC"),
                     getLatitude("University of Michigan, Ann Arbor, MI"),
                     getLatitude("University of Kentucky"),
                     getLatitude("Duke Durham, NC"),
                     getLatitude("Illinois State University, IL"),
                     getLatitude("Indiana University Bloomington, IN"),
                     getLatitude("Kansas University Lawrence, KS"),
                     getLatitude("St John's university, NY"),
                     getLatitude("California State Fullerton, CA"),
                     getLatitude("University of Louisville, KY"),
                     getLatitude("Michigan state university, MI"),
                     getLatitude("Notre Dame, IN"),
                     getLatitude("Ohio State University, OH"))


schoolLons <- c(getLongitude("University of california, Los Angeles, CA"),
                getLongitude("North Carolina Chapel hill, NC"),
                getLongitude("University of Michigan, Ann Arbor, MI"),
                getLongitude("University of Kentucky"),
                getLongitude("Duke Durham, NC"),
                getLongitude("Illinois State University, IL"),
                getLongitude("Indiana University Bloomington, IN"),
                getLongitude("Kansas University Lawrence, KS"),
                getLongitude("St John's university, NY"),
                getLongitude("California State Fullerton, CA"),
                getLongitude("University of Louisville, KY"),
                getLongitude("Michigan state university, MI"),
                getLongitude("Notre Dame, IN"),
                getLongitude("Ohio State University, OH"))


###Creating a new dataframe with the schools location
schoolStarsWithLoc <- data.frame(schoolStars,schoolLats,schoolLons)


#Generating the schools map
myBaseMap + geom_point(data = schoolStarsWithLoc,
                       aes(x = schoolLons, y = schoolLats,
                           color = allStar_players), 
                       size = 1.5) +
  scale_color_continuous(trans = 'reverse') + ggtitle("Top US all stars schools") +
  geom_text(data = schoolStarsWithLoc, aes(x = schoolLons, y = schoolLats, 
                                            label = SCHOOL, hjust=0, vjust=0, size = 1),size = 1.5) +
  theme(plot.title = element_text(hjust = 0.5))
    #Working with the International players data       
#Adding performance variable to the df
INTdf %>% mutate(performance = PTS + 2*AST + 1.5*REB) -> INTdf
#summarizing countries by overall performance

INTdf %>% group_by(COUNTRY) %>% summarise(sum(performance)) -> INTbyPerformance

#Renaming column and arranging the data
colnames(INTbyPerformance)[which(names(INTbyPerformance)== 
                                   "sum(performance)")] <- "total_performance"
  
INTbyPerformance <- INTbyPerformance %>% arrange(desc(total_performance)) 

top25Countries <- INTbyPerformance %>% slice(1:25)

#Generating the bar chart for the top 25 countries in ascending order
ggplot(top25Countries) + aes(x = reorder(COUNTRY, total_performance), y = total_performance) + 
  geom_bar(stat="identity", colour = "black", fill = "lightblue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Overall stats performance by country") + xlab("Country") +
  ylab("performance")



#Summarizing by both All Star appearances and performance

INT_allStars_Perf <- INTdf %>% group_by(COUNTRY) %>% summarise_at(c("ALL_STAR_APPEARANCES",
                                                               "performance"),sum)

filteredINT <- INT_allStars_Perf %>% filter(performance > mean(performance) & 
                                              ALL_STAR_APPEARANCES > 5)







