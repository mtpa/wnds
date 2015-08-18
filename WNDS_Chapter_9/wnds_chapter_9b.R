# Making Word Clouds: POTUS Speeches (R)

# install R wordcloud package

library(wordcloud)

# -----------------------------------
# word cloud for John F. Kennedy
# -----------------------------------
Kennedy.text <- scan("ALL_POTUS/Kennedy.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Kennedy.text <- tolower(Kennedy.text)
# strip out all non-letters and return vector
Kennedy.text.preword.vector <- unlist(strsplit(Kennedy.text, "\\W"))
# drop all empty words 
Kennedy.text.vector <- 
 Kennedy.text.preword.vector[which(nchar(Kennedy.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Kennedy_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Kennedy.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for Lyndon B. Johnson
# -----------------------------------
Johnson.text <- scan("ALL_POTUS/Johnson.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Johnson.text <- tolower(Johnson.text)
# strip out all non-letters and return vector
Johnson.text.preword.vector <- unlist(strsplit(Johnson.text, "\\W"))
# drop all empty words 
Johnson.text.vector <- 
 Johnson.text.preword.vector[which(nchar(Johnson.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Johnson_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Johnson.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for Richard M Nixon
# -----------------------------------
Nixon.text <- scan("ALL_POTUS/Nixon.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Nixon.text <- tolower(Nixon.text)
# strip out all non-letters and return vector
Nixon.text.preword.vector <- unlist(strsplit(Nixon.text, "\\W"))
# drop all empty words 
Nixon.text.vector <- 
 Nixon.text.preword.vector[which(nchar(Nixon.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Nixon_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Nixon.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for Gerald R. Ford
# -----------------------------------
Ford.text <- scan("ALL_POTUS/Ford.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Ford.text <- tolower(Ford.text)
# strip out all non-letters and return vector
Ford.text.preword.vector <- unlist(strsplit(Ford.text, "\\W"))
# drop all empty words 
Ford.text.vector <- 
 Ford.text.preword.vector[which(nchar(Ford.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Ford_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Ford.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for Jimmy Carter
# -----------------------------------
Carter.text <- scan("ALL_POTUS/Carter.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Carter.text <- tolower(Carter.text)
# strip out all non-letters and return vector
Carter.text.preword.vector <- unlist(strsplit(Carter.text, "\\W"))
# drop all empty words 
Carter.text.vector <- 
 Carter.text.preword.vector[which(nchar(Carter.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Carter_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Carter.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for Ronald Reagan
# -----------------------------------
Reagan.text <- scan("ALL_POTUS/Reagan.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Reagan.text <- tolower(Reagan.text)
# strip out all non-letters and return vector
Reagan.text.preword.vector <- unlist(strsplit(Reagan.text, "\\W"))
# drop all empty words 
Reagan.text.vector <- 
 Reagan.text.preword.vector[which(nchar(Reagan.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Reagan_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Reagan.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for George Bush
# -----------------------------------
BushG.text <- scan("ALL_POTUS/BushG.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
BushG.text <- tolower(BushG.text)
# strip out all non-letters and return vector
BushG.text.preword.vector <- unlist(strsplit(BushG.text, "\\W"))
# drop all empty words 
BushG.text.vector <- 
 BushG.text.preword.vector[which(nchar(BushG.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_BushG_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(BushG.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for William J. Clinton
# -----------------------------------
Clinton.text <- scan("ALL_POTUS/Clinton.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Clinton.text <- tolower(Clinton.text)
# strip out all non-letters and return vector
Clinton.text.preword.vector <- unlist(strsplit(Clinton.text, "\\W"))
# drop all empty words 
Clinton.text.vector <- 
 Clinton.text.preword.vector[which(nchar(Clinton.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Clinton_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Clinton.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for George W. Bush
# -----------------------------------
BushGW.text <- scan("ALL_POTUS/BushGW.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
BushGW.text <- tolower(BushGW.text)
# strip out all non-letters and return vector
BushGW.text.preword.vector <- unlist(strsplit(BushGW.text, "\\W"))
# drop all empty words 
BushGW.text.vector <- 
 BushGW.text.preword.vector[which(nchar(BushGW.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_BushGW_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(BushGW.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()

# -----------------------------------
# word cloud for Barack Obama
# -----------------------------------
Obama.text <- scan("ALL_POTUS/Obama.txt", what = "char", sep = "\n")
# replace uppercase with lowercase letters
Obama.text <- tolower(Obama.text)
# strip out all non-letters and return vector
Obama.text.preword.vector <- unlist(strsplit(Obama.text, "\\W"))
# drop all empty words 
Obama.text.vector <- 
 Obama.text.preword.vector[which(nchar(Obama.text.preword.vector) > 0)]
 
pdf(file = "fig_text_wordcloud_of_Obama_speeches.pdf", width = 8.5, height = 8.5)
set.seed(1234) 
wordcloud(Obama.text.vector, min.freq = 5,
  max.words = 150,
  random.order=FALSE,
  random.color=FALSE,
  rot.per=0.0,
  colors="black",
  ordered.colors=FALSE, 
  use.r.layout=FALSE,
  fixed.asp=TRUE)
dev.off()