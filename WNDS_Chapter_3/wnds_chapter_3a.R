# Extracting and Parsing Web Site Data (R)

# install required packages

# bring packages into the workspace
library(RCurl)  # functions for gathering data from the web
library(XML)  # XML and HTML parsing

# gather home page for ToutBay using RCurl package
web_page_text <- getURLContent('http://www.toutbay.com/')

# show the class of the R object and encoding
print(attributes(web_page_text))

# show the text including all of the HTML tags... lots of tags
print(web_page_text)

# parse the HTML DOM into an internal C data structure for XPath processing
web_page_tree <- htmlTreeParse(web_page_text, useInternalNodes = TRUE,
    asText = TRUE, isHTML = TRUE)
print(attributes(web_page_tree))

# extract the text within paragraph tags using an XPath query
# XPath // selects nodes anywhere in the document  p for paragraph tags
web_page_content <- xpathSApply(web_page_tree, "//p/text()")
print(attributes(web_page_content))
print(head(web_page_content))
print(tail(web_page_content))

# send content to external text file for review
sink("text_file_for_review.txt")
print(web_page_content)
sink()

# there are node numbers, line feed charachters, and spaces
# to delete from the text... but we have extracted the essential 
# content of the toutbay.com home page for further analysis