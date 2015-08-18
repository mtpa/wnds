# Analysis of Browser Usage (R)

# begin by installing necessary package ggplot2 

# load package into the workspace for this program
library(ggplot2)  # grammar of graphics plotting

# browser usage data from StatCounter Global Stats
# retrieved from the World Wide Web, October 21, 2014: 
# \url{http://gs.statcounter.com/#browser-ww-monthly-200807-201410
# read in comma-delimited text file 
browser_usage <- read.csv("browser_usage_2008_2014.csv")

# examine the data frame object
print(str(browser_usage))

# define Other category
browser_usage$Other <- 100 -
    browser_usage$IE - browser_usage$Chrome -
    browser_usage$Firefox - browser_usage$Safari 

# define time series data objects 
IE_ts <- ts(browser_usage$IE, start = c(2008, 7), frequency = 12)
Chrome_ts <- ts(browser_usage$Chrome, start = c(2008, 7), frequency = 12)
Firefox_ts <- ts(browser_usage$Firefox, start = c(2008, 7), frequency = 12)
Safari_ts <- ts(browser_usage$Safari, start = c(2008, 7), frequency = 12)
Other_ts <- ts(browser_usage$Other, start = c(2008, 7), frequency = 12)

# create a multiple time series object
browser_mts <- cbind(IE_ts, Chrome_ts, Firefox_ts, Safari_ts, Other_ts) 
dimnames(browser_mts)[[2]] <- c("IE", "Chrome", "Firefox", "Safari", "Other") 

# plot multiple time series object using standard R graphics
pdf(file="fig_browser_mts_R.pdf",width = 11,height = 8.5)  
ts.plot(browser_mts, ylab = "Percent Usage", main="", 
    plot.type = "single", col = 1:5)
legend("topright", colnames(browser_mts), col = 1:5,
    lty = 1, cex = 1)
dev.off()

# define Year as numeric with fractional values for months
browser_usage$Year <- as.numeric(time(IE_ts))

# build data frame for plotting a stacked area graph
Browser <- rep("IE", length = nrow(browser_usage))
Percent <- browser_usage$IE
Year <- browser_usage$Year
plotting_data_frame <- data.frame(Browser, Percent, Year) 

Browser <- rep("Chrome", length = nrow(browser_usage))
Percent <- browser_usage$Chrome
Year <- browser_usage$Year
plotting_data_frame <- rbind(plotting_data_frame, 
    data.frame(Browser, Percent, Year)) 
    
Browser <- rep("Firefox", length = nrow(browser_usage))
Percent <- browser_usage$Firefox
Year <- browser_usage$Year
plotting_data_frame <- rbind(plotting_data_frame, 
    data.frame(Browser, Percent, Year)) 
    
Browser <- rep("Safari", length = nrow(browser_usage))
Percent <- browser_usage$Safari
Year <- browser_usage$Year
plotting_data_frame <- rbind(plotting_data_frame, 
    data.frame(Browser, Percent, Year))
    
Browser <- rep("Other", length = nrow(browser_usage))
Percent <- browser_usage$Other
Year <- browser_usage$Year
plotting_data_frame <- rbind(plotting_data_frame, 
    data.frame(Browser, Percent, Year))    
    
# create ggplot plotting object and plot to external file
pdf(file = "fig_browser_usage_stacked_area_R.pdf", width = 11, height = 8.5)
area_plot <- ggplot(data = plotting_data_frame, 
    aes(x = Year, y = Percent, fill = Browser)) +
    geom_area(colour = "black", size = 1, alpha = 0.4) +
    scale_fill_brewer(palette = "Blues", 
        breaks = rev(levels(plotting_data_frame$Browser))) +
    theme(legend.text = element_text(size = 15))  +
    theme(legend.title = element_text(size = 15)) +
    theme(axis.title = element_text(size = 15))
print(area_plot)
dev.off()