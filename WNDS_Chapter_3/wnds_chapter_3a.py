# -*- coding: utf-8 -*-
# Extracting and Parsing Web Site Data (Python)

# prepare for Python version 3x features and functions
from __future__ import division, print_function

# import packages for web scraping/parsing
import requests  # functions for interacting with web pages
from lxml import html  # functions for parsing HTML
from bs4 import BeautifulSoup  # DOM html manipulation

# -----------------------------------------------
# demo using the requests and lxml packages
# -----------------------------------------------
# test requests package on the home page for ToutBay
web_page = requests.get('http://www.toutbay.com/', auth=('user', 'pass'))
# obtain the entire HTML text for the page of interest

# show the status of the page... should be 200 (no error)
web_page.status_code
# show the encoding of the page... should be utf8
web_page.encoding

# show the text including all of the HTML tags... lots of tags
web_page_text = web_page.text
print(web_page_text)

# parse the web text using html functions from lxml package
# store the text with HTML tree structure
web_page_html = html.fromstring(web_page_text)

# extract the text within paragraph tags using an lxml XPath query
# XPath // selects nodes anywhere in the document  p for paragraph tags
web_page_content = web_page_html.xpath('//p/text()') 
# show the resulting text string object
print(web_page_content)  # has a few all-blank strings
print(len(web_page_content))
print(type(web_page_content))  # a list of character strings

# -----------------------------------------------------------
# demo of parsing HTML with beautiful soup instead of lxml
# -----------------------------------------------------------
my_soup = BeautifulSoup(web_page_text)
# note that my_soup is a BeautifulSoup object
print(type(my_soup))

# remove JavaScript code from Beautiful Soup page object
# using a comprehension approach
[x.extract() for x in my_soup.find_all('script')] 

# gather all the text from the paragraph tags within the object
# using another list comprehension 
soup_content = [x.text for x in my_soup.find_all('p')]
# show the resulting text string object
print(soup_content)  # note absence of all-blank strings
print(len(soup_content))  
print(type(soup_content))  # a list of character strings

# there are carriage return, line feed characters, and spaces
# to delete from the text... but we have extracted the essential 
# content of the toutbay.com home page for further analysis