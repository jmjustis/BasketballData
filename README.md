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


### Data preparation for business question 3:




