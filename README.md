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
6. Validation
7. Appendix - Code

***
## 1. Introduction

Our approach was to put ourselves in the shoes of a management team that is assigned to put together the best NBA team possible. Our team put together a set of fundamental business questions that will help us determine where the team can save in costs as well as where to look for talent. We believe that our managerial approach is significally a better and more scientific approach rather than blindly trying to put together a team. 

## 2. Business Questions
1. Is there a relationship between a player’s salary and player’s performance?
    * Do the same players with the highest PRA (points, rebounds & assists) make the most money?

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

### Data preparation for business question 1:

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












### Data preparation for business question 2:
# Is there a relationship between salary and player performance?
## Data Cleanse and preparation
In our data set the salary for players and the performance were located in two different tables.  The salary was listed for each contract, which meant in the salary table each player had multiple rows.  The first step to getting the data set ready was to group the contracts by the players name and get both the sum and average contract for each player in the salary table.
 ![Picture1](https://user-images.githubusercontent.com/80026659/208272688-3c842eec-723e-4c28-99b3-5d354dda0c40.png)

After getting the salary dataset grouped by player with both sum and average contract, we could combine in with the table containing player performance statistics.
![Picture10](https://user-images.githubusercontent.com/80026659/208272762-04d0b7ee-fe60-43ea-8ae9-dbb6d63049fa.png)


After merging the datasets we were left with 415 players that had both player performance statistics as well as salary data.  We then added the statistics Points, Rebounds, and Assists into one variable called PRA.
![Picture2](https://user-images.githubusercontent.com/80026659/208272691-31bc6d90-c9ee-47a0-84a4-4cc79ebc0bc4.png)




## Descriptive Statistics and Visualizations
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









## Data Modeling
### Linear Models
For the salary dataset we did two linear models with both total salary and average salary vs our performance statistic, PRA.  
![Picture8](https://user-images.githubusercontent.com/80026659/208272780-f04181cc-5448-4bb1-8aaf-b854566bd498.png)
![Picture9](https://user-images.githubusercontent.com/80026659/208272782-2ba9a953-4c9d-413f-b449-29c4451d49bb.png)

 
The first linear model for total salary has an adjusted R squared value of .53 which means that approximately 53% of the variance in total salary is explained by our performance statistic.  Average salary has a higher adjusted R squared with 62% of the variance in average salary being explained by the performance statistic.


### Data preparation for business question 3:




