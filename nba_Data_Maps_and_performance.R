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

