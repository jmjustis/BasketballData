library(readr)
library(sqldf)
library(RSQLite)
library(tidyverse)


df <- read_csv('C:/Users/ijo28/Downloads/nba_players.csv')




library(tidyverse)
df <- df[,-1] #Getting rid of the indexes



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





#Generating the maps 
library(ggmap)
library(maps)
US <- map_data("state")
map.simple <- ggplot(US)

myBaseMap <- map.simple + geom_polygon(color='black', fill = 'wheat1',
                                       aes(x=long, y = lat, group = group)) + coord_map()

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


