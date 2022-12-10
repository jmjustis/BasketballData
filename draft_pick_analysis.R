#IST 687 Project
#Authors

#Objective:


##########################################################################
#Step 1: Import database of NBA data:

library(tidyverse)
library(ggplot2)


#exploring database

player_attributes_df <- read_csv('C:\\Users\\nicky\\Desktop\\IST 687\\Project\\player_attributes.csv')
view(player_attributes_df)
str(player_attributes_df)

#################
#Business Question
#How significant is the the first draft pick?
  # does a first round pick player perform?
  #How does a first round pick player perform against the last round pick?
  #If you are a basketball team manager, is it worth it to spend extra?
#################

#I have to decide what columns I will want to need and what columns I do not.Then, create new dataframe called df.  

df <- select(player_attributes_df,ID,FIRST_NAME,LAST_NAME,TEAM_NAME,SCHOOL,COUNTRY,POSITION,DRAFT_YEAR,DRAFT_NUMBER,PTS,AST,REB,ALL_STAR_APPEARANCES)
df


#next we will have to remove rows that show NA in the columns we need

na.omit(df$ALL_STAR_APPEARANCES)
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



#visualizations

myplot <- ggplot(df, aes(x=DRAFT_NUMBER, y=ALL_STAR_APPEARANCES)) + geom_point() 
myplot

#

#creating a column to calculate player with best stats by adding points, assists and rebounds

TOTAL_POINTS <- df$PTS+df$AST+df$REB
TOTAL_POINTS
df$TOTAL_POINTS <- c(TOTAL_POINTS)
str(df)

myplot2 <- ggplot(df, aes(x=DRAFT_NUMBER, y=TOTAL_POINTS)) + geom_point()
myplot2

myplot3 <- ggplot(df, aes(x=DRAFT_NUMBER, y=TOTAL_POINTS)) + geom_point() + geom_smooth(method=lm)
myplot3



#Histograms with top 10 schools

df2 <- df[order(-TOTAL_POINTS),]
df3<- head(df2,10)
view(df3)

myplot5 <-ggplot(data=df, aes(x=SCHOOL, y=TOTAL_POINTS)) + geom_bar(stat="identity")
myplot5
view(df)






