# Website Traffic Analysis (R)

# begin by installing necessary package ggplot2 

# load packages into the workspace for this program
library(gridExtra)  # grid plotting utilities
library(ggplot2)  # grammar of graphics plotting
library(lubridate)  # date and time functions
library(riverplot)  # Sankey diagrams
library(RColorBrewer)  # colors for plots

# user-defined function to convert hh:mm:ss to seconds
make_seconds <- function(hhmmss) {
    hhmmss_list <- strsplit(hhmmss, split = ":")
    3600 * as.numeric(hhmmss_list[[1]][1]) +
        60 * as.numeric(hhmmss_list[[1]][2]) +
        as.numeric(hhmmss_list[[1]][3])
    }    
    
# read in data from ToutBay Begins case
toutbay_begins <- read.csv("toutbay_begins.csv", stringsAsFactors = FALSE)

# examine the data frame object
print(str(toutbay_begins))

# set date as date object
toutbay_begins$date <- parse_date_time(toutbay_begins$date, "mdy")

# convert ave_session_duration to ave_session_seconds, total_session_seconds
toutbay_begins$ave_session_seconds <- numeric(nrow(toutbay_begins))
for (i in seq(along = toutbay_begins$ave_session_duration)) 
    toutbay_begins$ave_session_seconds[i] <- 
        make_seconds(toutbay_begins$ave_session_duration[i])
# compute total seconds across all sessions in the day
toutbay_begins$total_session_seconds <-
    toutbay_begins$ave_session_seconds * toutbay_begins$sessions

# 161 days = 23 weeks so we can index by weeks
week <- NULL
for (i in 1:23) week <- c(week, rep(i, times = 7))
toutbay_begins$week <- week

# compute other_browser browser counts
toutbay_begins$other_browser <- toutbay_begins$sessions -
    toutbay_begins$chrome - toutbay_begins$safari -
    toutbay_begins$firefox - toutbay_begins$internet_explorer
    
# compute other_system operating system counts (Linux and others)
toutbay_begins$other_system <- toutbay_begins$sessions -
    toutbay_begins$windows - toutbay_begins$macintosh -
    toutbay_begins$ios - toutbay_begins$android    

# extract daily counts and totals
toutbay_daily <- toutbay_begins[, 
    c("date", "week", "sessions", "users", "pageviews", "scroll_videopromo",    
      "scroll_whatstoutbay", "scroll_howitworks", "scroll_faq",           
       "scroll_latestfeeds", "internet_explorer", "chrome", "firefox", 
       "safari", "other_browser", "windows", "macintosh", "ios", "android",              
       "other_system", "total_session_seconds")]
# examine the daily data frame
print(str(toutbay_daily))
print(head(toutbay_daily))

# aggregate by week using sum()
toutbay_weekly <- 
    aggregate(toutbay_daily[, setdiff(names(toutbay_daily), c("date","week"))], 
    by = list(toutbay_daily$week), FUN = sum)
names(toutbay_weekly)[1] <- "week"  # rename first column of data frame

# compute average session duration in seconds
toutbay_weekly$ave_session_seconds <- 
    toutbay_weekly$total_session_seconds / toutbay_weekly$sessions

# examine the weekly data frame
print(str(toutbay_weekly))
print(head(toutbay_weekly))

# create browser data frame for plotting
Browser <- "IE"
Count <- sum(toutbay_weekly$internet_explorer)
browser_data_frame <- data.frame(Browser, Count)
Browser <- "Chrome"
Count <- sum(toutbay_weekly$chrome)
browser_data_frame <- rbind(browser_data_frame,
    data.frame(Browser, Count))
Browser <- "Firefox"
Count <- sum(toutbay_weekly$firefox)
browser_data_frame <- rbind(browser_data_frame,
    data.frame(Browser, Count))
Browser <- "Safari"
Count <- sum(toutbay_weekly$safari)
browser_data_frame <- rbind(browser_data_frame,
    data.frame(Browser, Count))    
Browser <- "Other"
Count <- sum(toutbay_weekly$other_browser)
browser_data_frame <- rbind(browser_data_frame,
    data.frame(Browser, Count))

pdf(file = "fig_toutbay_begins_user_browsers_R.pdf", width = 11, height = 8.5)
browser_bar_plot <- ggplot(data = browser_data_frame,
    aes(x = Browser, y = Count)) + 
    geom_bar(stat = "identity", width = 0.75, 
        colour = "black", fill = "darkblue") +
    ylim(0, 225) +
    theme(axis.title.y = element_text(size = 15, colour = "black")) +
    theme(axis.title.x = element_blank()) +
    theme(axis.text.x = element_text(size = 15, colour = "black")) +
    annotate("text", x = 1, y = browser_data_frame$Count[1] + 5, 
        label = paste(as.character(round(100 * browser_data_frame$Count[1]/
            sum(browser_data_frame$Count), digits = 0)), "%", sep = "")) +
    annotate("text", x = 2, y = browser_data_frame$Count[2] + 5, 
        label = paste(as.character(round(100 * browser_data_frame$Count[2]/
            sum(browser_data_frame$Count), digits = 0)), "%", sep = "")) +   
    annotate("text", x = 3, y = browser_data_frame$Count[3] + 5, 
        label = paste(as.character(round(100 * browser_data_frame$Count[3]/
            sum(browser_data_frame$Count), digits = 0)), "%", sep = "")) +
    annotate("text", x = 4, y = browser_data_frame$Count[4] + 5, 
        label = paste(as.character(round(100 * browser_data_frame$Count[4]/
            sum(browser_data_frame$Count), digits = 0)), "%", sep = "")) +
    annotate("text", x = 5, y = browser_data_frame$Count[5] + 5, 
        label = paste(as.character(round(100 * browser_data_frame$Count[5]/
            sum(browser_data_frame$Count), digits = 0)), "%", sep = ""))            
print(browser_bar_plot)
dev.off()

# create operating system data frame for plotting
System <- "Windows"
Count <- sum(toutbay_weekly$windows)
system_data_frame <- data.frame(System, Count)
System <- "Macintosh"
Count <- sum(toutbay_weekly$macintosh)
system_data_frame <- rbind(system_data_frame,
    data.frame(System, Count))
System <- "iOS"
Count <- sum(toutbay_weekly$ios)
system_data_frame <- rbind(system_data_frame,
    data.frame(System, Count))
System <- "Android"
Count <- sum(toutbay_weekly$android)
system_data_frame <- rbind(system_data_frame,
    data.frame(System, Count))    
System <- "Other"
Count <- sum(toutbay_weekly$other_system)
system_data_frame <- rbind(system_data_frame,
    data.frame(System, Count))

pdf(file = "fig_toutbay_begins_user_systems_R.pdf", width = 11, height = 8.5)
system_bar_plot <- ggplot(data = system_data_frame,
    aes(x = System, y = Count)) + 
    geom_bar(stat = "identity", width = 0.75, 
        colour = "black", fill = "darkblue") +
    ylim(0, max(system_data_frame$Count + 15)) +
    theme(axis.title.y = element_text(size = 15, colour = "black")) +
    theme(axis.title.x = element_blank()) +
    theme(axis.text.x = element_text(size = 15, colour = "black")) +
    annotate("text", x = 1, y = system_data_frame$Count[1] + 5, 
        label = paste(as.character(round(100 * system_data_frame$Count[1]/
            sum(system_data_frame$Count), digits = 0)), "%", sep = "")) +
    annotate("text", x = 2, y = system_data_frame$Count[2] + 5, 
        label = paste(as.character(round(100 * system_data_frame$Count[2]/
            sum(system_data_frame$Count), digits = 0)), "%", sep = "")) +   
    annotate("text", x = 3, y = system_data_frame$Count[3] + 5, 
        label = paste(as.character(round(100 * system_data_frame$Count[3]/
            sum(system_data_frame$Count), digits = 0)), "%", sep = "")) +
    annotate("text", x = 4, y = system_data_frame$Count[4] + 5, 
        label = paste(as.character(round(100 * system_data_frame$Count[4]/
            sum(system_data_frame$Count), digits = 0)), "%", sep = "")) +
    annotate("text", x = 5, y = system_data_frame$Count[5] + 5, 
        label = paste(as.character(round(100 * system_data_frame$Count[5]/
            sum(system_data_frame$Count), digits = 0)), "%", sep = ""))            
print(system_bar_plot)
dev.off()

# plot multiple time series for sessions, pageviews, and session duration
pdf(file = "fig_toutbay_begins_site_stats_R.pdf", width = 8.5, height = 11)
sessions_plot <- ggplot(data = toutbay_weekly,
    aes(x = week, y = sessions)) + geom_line()  +
    ylab("Sessions") +
    theme(axis.title.x = element_blank()) +
    annotate("rect", xmin = 11.75, xmax = 13.25, 
        ymin = 0, ymax = max(toutbay_weekly$sessions), 
        fill = "blue", alpha = 0.4) 
  
pageviews_plot <- ggplot(data = toutbay_weekly,
    aes(x = week, y = pageviews)) + geom_line() +
    ylab("Page Views") +
    theme(axis.title.x = element_blank()) +
    annotate("rect", xmin = 11.75, xmax = 13.25, 
        ymin = 0, ymax = max(toutbay_weekly$pageviews), 
        fill = "blue", alpha = 0.4) 

duration_plot <- ggplot(data = toutbay_weekly,
    aes(x = week, y = ave_session_seconds)) + geom_line() +
    xlab("Week of Operation") +
    ylab("Seconds") +
    theme(axis.title.x = element_text(size = 15, colour = "black")) +
    annotate("rect", xmin = 11.75, xmax = 13.25, 
        ymin = 0, ymax = max(toutbay_weekly$ave_session_seconds), 
        fill = "blue", alpha = 0.4) +
    annotate("text", x = 12.5, y = 20, size = 4, colour = "white",
        label = "UseR!") 

mts_plot <- grid.arrange(sessions_plot, pageviews_plot,
    duration_plot, ncol = 1, nrow = 3)
print(mts_plot)
dev.off()
    
# construct Sankey diagram for home page scrolling
pdf(file = "fig_toutbay_begins_sankey_R.pdf", width = 8.5, height = 11)
nodes <- data.frame(ID = c("A","B","C","D","E","F","G"),
    x = c(1, 2, 3, 4, 5, 6, 6),
    y = c(7, 7.5, 8, 8.5, 9, 9.5, 6),
    labels = c("Top",
               "Video",
               "What?",
               "How?",
               "FAQ",
               "News",
               "Exit"),
               stringsAsFactors = FALSE, 
               row.names = c("A","B","C","D","E","F","G"))
edges <- data.frame(N1 = c("A","B","C","D","E",
                           "A","B","C","D","E"),
                    N2 = c("G","G","G","G","G",
                           "B","C","D","E","F"),
    Value = c(
    sum(toutbay_weekly$sessions)- sum(toutbay_weekly$scroll_videopromo),
    sum(toutbay_weekly$scroll_videopromo) - 
        sum(toutbay_weekly$scroll_whatstoutbay),
    sum(toutbay_weekly$scroll_whatstoutbay) - 
        sum(toutbay_weekly$scroll_howitworks),
    sum(toutbay_weekly$scroll_howitworks) - sum(toutbay_weekly$scroll_faq),
    sum(toutbay_weekly$scroll_faq) - sum(toutbay_weekly$scroll_latestfeeds),
    sum(toutbay_weekly$scroll_videopromo),
    sum(toutbay_weekly$scroll_whatstoutbay),
    sum(toutbay_weekly$scroll_howitworks),
    sum(toutbay_weekly$scroll_faq),
    sum(toutbay_weekly$scroll_latestfeeds)), row.names = NULL)
    
selected_pallet <- brewer.pal(9, "Blues")
river_object <- makeRiver(nodes, edges,  
    node_styles = 
    list(A = list(col = selected_pallet[9], textcol = "white"),
    B = list(col = selected_pallet[8], textcol = "white"),
    C = list(col = selected_pallet[7], textcol = "white"),
    D = list(col = selected_pallet[6], textcol = "white"),
    E = list(col = selected_pallet[5], textcol = "white"),
    F = list(col = selected_pallet[5], textcol = "white"),
    G = list(col = "darkred", textcol = "white")))
plot(river_object, nodewidth = 4, srt = TRUE) 
dev.off()