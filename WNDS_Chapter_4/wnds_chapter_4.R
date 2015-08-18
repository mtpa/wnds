# Identifying Keywords for Testing Performance in Search (R)

# begin by installing necessary package RJSONIO

# load package into the workspace for this program
library(RJSONIO)  # JSON to/from R objects

# read Angels keyword data from Google AdWords Keyword Planner
angels_1 <- read.csv("tickets_angels/tickets_angels_arts_entertainment.csv", 
    stringsAsFactors = FALSE)
angels_2 <- read.csv("tickets_angels/tickets_angels_baseball.csv", 
    stringsAsFactors = FALSE)
angels_3 <- read.csv("tickets_angels/tickets_angels_sports_entertainment.csv", 
    stringsAsFactors = FALSE)
angels_4 <- read.csv("tickets_angels/tickets_angels_sports_events_ticketing.csv", 
    stringsAsFactors = FALSE)
angels_5 <- read.csv("tickets_angels/tickets_angels_sports_fitness.csv", 
    stringsAsFactors = FALSE)
angels_6 <- read.csv("tickets_angels/tickets_angels_sports.csv", 
    stringsAsFactors = FALSE)    
    
# read Dodgers keyword data from Google AdWords Keyword Planner
dodgers_1 <- read.csv("tickets_dodgers/tickets_dodgers_arts_entertainment.csv", 
    stringsAsFactors = FALSE)
dodgers_2 <- read.csv("tickets_dodgers/tickets_dodgers_baseball.csv", 
    stringsAsFactors = FALSE)
dodgers_3 <- read.csv("tickets_dodgers/tickets_dodgers_sports_entertainment.csv", 
    stringsAsFactors = FALSE)
dodgers_4 <- read.csv("tickets_dodgers/tickets_dodgers_sports_events_ticketing.csv", 
    stringsAsFactors = FALSE)
dodgers_5 <- read.csv("tickets_dodgers/tickets_dodgers_sports_fitness.csv", 
    stringsAsFactors = FALSE)
dodgers_6 <- read.csv("tickets_dodgers/tickets_dodgers_sports.csv", 
    stringsAsFactors = FALSE)    
    
# check column names to ensure matches
names(angels_1) == names(angels_2)
names(angels_1) == names(angels_3)
names(angels_1) == names(angels_4)
names(angels_1) == names(angels_5)
names(angels_1) == names(angels_6)
names(angels_1) == names(dodgers_1)
names(angels_1) == names(dodgers_2)
names(angels_1) == names(dodgers_3)
names(angels_1) == names(dodgers_4)
names(angels_1) == names(dodgers_5)
names(angels_1) == names(dodgers_6)

# define simple column names prior to merging data frames
names(angels_1) <- names(angels_2) <- names(angels_3) <-
    names(angels_4) <- names(angels_5) <- names(angels_6) <-
    names(dodgers_1) <- names(dodgers_2) <- names(dodgers_3) <-
    names(dodgers_4) <- names(dodgers_5) <- names(dodgers_6) <-
    c("group", "keyword", "currency",                                
    "traffic", "october", "november", "december", "january",                      
    "february", "march", "april", "may", "june", "july",                      
    "august", "september", "competition", "cpcbid")

# add study category to each record of each data frame
angels_1$study <- rep("Arts and Entertainment", length = nrow(angels_1))
angels_2$study <- rep("Baseball", length = nrow(angels_2))
angels_3$study <- rep("Sports Entertainment", length = nrow(angels_3))
angels_4$study <- rep("Sports Events Ticketing", length = nrow(angels_4))
angels_5$study <- rep("Sports and Fitness", length = nrow(angels_5))
angels_6$study <- rep("Sports", length = nrow(angels_6))
dodgers_1$study <- rep("Arts and Entertainment", length = nrow(dodgers_1))
dodgers_2$study <- rep("Baseball", length = nrow(dodgers_2))
dodgers_3$study <- rep("Sports Entertainment", length = nrow(dodgers_3))
dodgers_4$study <- rep("Sports Events Ticketing", length = nrow(dodgers_4))
dodgers_5$study <- rep("Sports and Fitness", length = nrow(dodgers_5))
dodgers_6$study <- rep("Sports", length = nrow(dodgers_6))

# add team name to each record of each data frame
angels_1$team <- rep("Angels", length = nrow(angels_1))
angels_2$team <- rep("Angels", length = nrow(angels_2))
angels_3$team <- rep("Angels", length = nrow(angels_3))
angels_4$team <- rep("Angels", length = nrow(angels_4))
angels_5$team <- rep("Angels", length = nrow(angels_5))
angels_6$team <- rep("Angels", length = nrow(angels_6))
dodgers_1$team <- rep("Dodgers", length = nrow(dodgers_1))
dodgers_2$team <- rep("Dodgers", length = nrow(dodgers_2))
dodgers_3$team <- rep("Dodgers", length = nrow(dodgers_3))
dodgers_4$team <- rep("Dodgers", length = nrow(dodgers_4))
dodgers_5$team <- rep("Dodgers", length = nrow(dodgers_5))
dodgers_6$team <- rep("Dodgers", length = nrow(dodgers_6))
  
# combine the data frames
keyword_data_frame <- rbind(angels_1, angels_2, angels_3,
    angels_4, angels_5, angels_6, dodgers_1, dodgers_2, 
    dodgers_3, dodgers_4, dodgers_5, dodgers_6)
    
# drop currency variable because everything is in US dollars  
keyword_data_frame <- keyword_data_frame[, -3]   # currency is thrid column

# drop cases with missing values
keyword_data_frame <- na.omit(keyword_data_frame)

# examine the structure of the data frame
print(str(keyword_data_frame))

# select Sports category for both Dodgers and Angels 
sports_data_frame <- subset(keyword_data_frame, 
    subset = (study == "Sports"))
print(str(sports_data_frame))
# check on the keywords used for Sports (sports_data_frame)
with(sports_data_frame, print(table(keyword)))  # many not relevant

# distribution of cost-per-click bids
with(sports_data_frame, plot(density(cpcbid)))  # a few very high values

# relationship between traffic and cost-per-click bids
# weak positive relationship
with(sports_data_frame,
    cat("\n\nCorrelation between traffic and suggested CPC bid:",
        cor(traffic, cpcbid)))
with(sports_data_frame, plot(traffic, cpcbid))  

# relationship between competition and cost-per-click bids
# moderate positive relationship
with(sports_data_frame,
    cat("\n\nCorrelation between competitors and CPC and suggested CPCbid:",
        cor(competition, cpcbid)))
with(sports_data_frame, plot(competition, cpcbid))  

# select Baseball category for both Dodgers and Angels  
baseball_data_frame <- subset(keyword_data_frame, 
    subset = (study == "Baseball"))
print(str(baseball_data_frame))
# check on the keywords used for Baseball (baseball_data_frame)
with(baseball_data_frame, print(table(keyword)))  # many not relevant

# traffic estimates for keyword: "baseball tickets for sale"
# note identical values for Dodgers and Angels
baseball_tickets_for_sale_data_frame <- subset(baseball_data_frame,
        subset = (keyword == "baseball tickets for sale"))
print(baseball_tickets_for_sale_data_frame)   

# traffic estimates for keyword: "dodgers tickets"
# note identical values for Dodgers and Angels
dodgers_tickets_data_frame <- subset(baseball_data_frame,
        subset = (keyword == "dodgers tickets"))
print(dodgers_tickets_data_frame) 

# traffic estimates for keyword: "angels tickets"
# note identical values for Dodgers and Angels
# interesting that "angels tickets" has lower traffic
# estimates than "dodgers tickets" but a higher CPC
angels_tickets_data_frame <- subset(baseball_data_frame,
        subset = (keyword == "angels tickets"))
print(angels_tickets_data_frame) 

# what about "baseball tickets" across all the studies
# this occurs in three of the categories for both Dodgers and Angels
# note the expected seasonal pattern in traffic
# also note identical traffic estimates for March, April, and May
# and identical values for June and July... a clear indication 
# that these are not actual data... nor are they likely to have
# come from a data-based predictive model... there is too much 
# regularity across the time series of monthly traffic estimates
baseball_tickets_data_frame <- subset(keyword_data_frame,
        subset = (keyword == "baseball tickets"))
print(baseball_tickets_data_frame) 

# select Sports Entertainment for keyword search
working_data_frame <- subset(keyword_data_frame,
    subset = (study == "Sports Entertainment"))
print(str(working_data_frame))    

# rank keyword records by traffic estimate (highest first)
sorted_data_frame <- 
    working_data_frame[sort.list(working_data_frame$traffic, 
        decreasing = TRUE),]

# consider only unique keywords in the sorted list
preliminary_keyword_list <- unique(sorted_data_frame$keyword)
cat("\n\n", length(preliminary_keyword_list), 
  "keywords in preliminary list\n")

# output the list for review with the intention of selecting
# a subset of keywords relevant to both the Dodgers and Angels
# we use a JSON file for this purpose
json_string <- toJSON(preliminary_keyword_list)
# remove backslashes from string
sink("preliminary_json.txt")
json_string
sink()
