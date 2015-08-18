# From Text Measures to Text Maps: POTUS Speeches (R)

# install R wordcloud package

library(ggplot2)  # grammar of graphics plotting system

# --------------------
#  Presidents Studied
# --------------------
#  John F. Kennedy
#  Lyndon B. Johnson
#  Richard M Nixon
#  Gerald R. Ford
#  Jimmy Carter
#  Ronald Reagan
#  George Bush
#  William J. Clinton
#  George W. Bush
#  Barack Obama
# --------------------

# read in results from multidimensional scaling analysis
mds_data_frame <- read.csv("POTUS_mds.csv", stringsAsFactors = FALSE)
print(str(mds_data_frame))

mds_data_frame$year_label <- as.character(mds_data_frame$year)

mds_data_frame$party_label <- rep("", length = nrow(mds_data_frame))
for (i in seq(along = mds_data_frame$party)) {
    if(mds_data_frame$party[i] == "D") 
        mds_data_frame$party_label[i] <- "Democrat"
    if(mds_data_frame$party[i] == "R") 
        mds_data_frame$party_label[i] <- "Republican"
    }

# direct manipulation of text positioning to avoid overlapping text
mds_data_frame$pres_x <- mds_data_frame$first_dimension + 0.025
mds_data_frame$pres_y <- mds_data_frame$second_dimension + 0.015
mds_data_frame$year_x <- mds_data_frame$first_dimension + 0.025
mds_data_frame$year_y <- mds_data_frame$second_dimension - 0.015

# Carter 1979 up and to the left
mds_data_frame$pres_x[2] <- mds_data_frame$first_dimension[2] + 0.025 -0.0225
mds_data_frame$pres_y[2] <- mds_data_frame$second_dimension[2] + 0.015 + 0.035 
mds_data_frame$year_x[2] <- mds_data_frame$first_dimension[2] + 0.025 -0.0225
mds_data_frame$year_y[2] <- mds_data_frame$second_dimension[2] - 0.015 + 0.035 

# Clinton 1994 move down
mds_data_frame$pres_x[5] <- mds_data_frame$first_dimension[5] + 0.025 
mds_data_frame$pres_y[5] <- mds_data_frame$second_dimension[5] + 0.015 - 0.0125
mds_data_frame$year_x[5] <- mds_data_frame$first_dimension[5] + 0.025
mds_data_frame$year_y[5] <- mds_data_frame$second_dimension[5] - 0.015 - 0.0125

# Clinton 2000 up and to the left
mds_data_frame$pres_x[11] <- mds_data_frame$first_dimension[11] + 0.025 -0.0325
mds_data_frame$pres_y[11] <- mds_data_frame$second_dimension[11] + 0.015 + 0.045 
mds_data_frame$year_x[11] <- mds_data_frame$first_dimension[11] + 0.025 -0.0325
mds_data_frame$year_y[11] <- mds_data_frame$second_dimension[11] - 0.015 + 0.045 

# Kennedy 1961 move up and to the left
mds_data_frame$pres_x[17] <- mds_data_frame$first_dimension[17] + 0.025 -0.0455
mds_data_frame$pres_y[17] <- mds_data_frame$second_dimension[17] + 0.015 + 0.04
mds_data_frame$year_x[17] <- mds_data_frame$first_dimension[17] + 0.025 - 0.0455
mds_data_frame$year_y[17] <- mds_data_frame$second_dimension[17] - 0.015 + 0.04

# Kennedy 1963 move down
mds_data_frame$pres_x[19] <- mds_data_frame$first_dimension[19] + 0.025 
mds_data_frame$pres_y[19] <- mds_data_frame$second_dimension[19] + 0.015 - 0.0125
mds_data_frame$year_x[19] <- mds_data_frame$first_dimension[19] + 0.025 
mds_data_frame$year_y[19] <- mds_data_frame$second_dimension[19] - 0.015 - 0.0125

# Obama 2009 move up
mds_data_frame$pres_x[20] <- mds_data_frame$first_dimension[20] + 0.025 
mds_data_frame$pres_y[20] <- mds_data_frame$second_dimension[20] + 0.015 + 0.0125
mds_data_frame$year_x[20] <- mds_data_frame$first_dimension[20] + 0.025 
mds_data_frame$year_y[20] <- mds_data_frame$second_dimension[20] - 0.015 + 0.0125

# Obama 2010 move down and to the left
mds_data_frame$pres_x[21] <- mds_data_frame$first_dimension[21] + 0.025 -0.0125
mds_data_frame$pres_y[21] <- mds_data_frame$second_dimension[21] + 0.015 - 0.03
mds_data_frame$year_x[21] <- mds_data_frame$first_dimension[21] + 0.025 -0.0125
mds_data_frame$year_y[21] <- mds_data_frame$second_dimension[21] - 0.015 - 0.03

# Obama 2011 move up and to the left
mds_data_frame$pres_x[22] <- mds_data_frame$first_dimension[22] + 0.025 -0.0125
mds_data_frame$pres_y[22] <- mds_data_frame$second_dimension[22] + 0.015 + 0.0355
mds_data_frame$year_x[22] <- mds_data_frame$first_dimension[22] + 0.025 -0.0125
mds_data_frame$year_y[22] <- mds_data_frame$second_dimension[22] - 0.015 + 0.0355

# Obama 2014 move up and to the left
mds_data_frame$pres_x[25] <- mds_data_frame$first_dimension[25] + 0.025 -0.0255
mds_data_frame$pres_y[25] <- mds_data_frame$second_dimension[25] + 0.015 + 0.0415
mds_data_frame$year_x[25] <- mds_data_frame$first_dimension[25] + 0.025 - 0.0255
mds_data_frame$year_y[25] <- mds_data_frame$second_dimension[25] - 0.015 + 0.0415

# BushG 1990 move down
mds_data_frame$pres_x[27] <- mds_data_frame$first_dimension[27] + 0.025 
mds_data_frame$pres_y[27] <- mds_data_frame$second_dimension[27] + 0.015 - 0.0125
mds_data_frame$year_x[27] <- mds_data_frame$first_dimension[27] + 0.025
mds_data_frame$year_y[27] <- mds_data_frame$second_dimension[27] - 0.015 - 0.0125

# BushG 1992 move down
mds_data_frame$pres_x[29] <- mds_data_frame$first_dimension[29] + 0.025 
mds_data_frame$pres_y[29] <- mds_data_frame$second_dimension[29] + 0.015 - 0.0125
mds_data_frame$year_x[29] <- mds_data_frame$first_dimension[29] + 0.025
mds_data_frame$year_y[29] <- mds_data_frame$second_dimension[29] - 0.015 - 0.0125

# Nixon 1970 move up
mds_data_frame$pres_x[40] <- mds_data_frame$first_dimension[40] + 0.025 
mds_data_frame$pres_y[40] <- mds_data_frame$second_dimension[40] + 0.015 + 0.0125
mds_data_frame$year_x[40] <- mds_data_frame$first_dimension[40] + 0.025 
mds_data_frame$year_y[40] <- mds_data_frame$second_dimension[40] - 0.015 + 0.0125

# Reagan 1988 move up
mds_data_frame$pres_x[52] <- mds_data_frame$first_dimension[52] + 0.025 
mds_data_frame$pres_y[52] <- mds_data_frame$second_dimension[52] + 0.015 + 0.0125
mds_data_frame$year_x[52] <- mds_data_frame$first_dimension[52] + 0.025 
mds_data_frame$year_y[52] <- mds_data_frame$second_dimension[52] - 0.015 + 0.0125

pdf(file = "fig_mds_solution_POTUS_Speeches.pdf", width = 8.5, height = 8.5) 
ggplot_object <- ggplot(data = mds_data_frame, 
    aes(x = first_dimension, y = second_dimension, 
        shape = party_label, colour = party_label)) + 
    geom_point(size = 3) +
    scale_colour_manual(values = 
        c(Democrat = "darkblue", Republican = "darkred")) +
    geom_text(aes(x = pres_x , y = pres_y, label = pres), 
        size = 4, hjust = 0, colour = "black") +
    geom_text(aes(x = year_x , y = year_y, label = year_label), 
        size = 3, hjust = 0, colour = "black") +    
    xlim(-0.70, 0.85) +  
    xlab("People-to-Government Focus") +
    ylab("International-to-Domestic Focus") +
    theme(axis.title.x = element_text(size = 15, colour = "black")) +
    theme(axis.title.y = element_text(size = 15, colour = "black")) +
    theme(axis.text.x = element_text(colour = "white")) +
    theme(axis.text.y = element_text(colour = "white")) +
    theme(legend.position = "bottom") +
    theme(legend.title = element_text(size = 0.000001)) +
    theme(legend.text = element_text(size = 15))
print(ggplot_object)  
dev.off()

