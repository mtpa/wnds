# Crawling and Scraping while Napping (Python)
#
# Focused Crawl with a Ten-Headed Spider Using the Scrapy Framework 
#
# prepare for Python version 3x features and functions
from __future__ import division, print_function

# scrapy documentation at http://doc.scrapy.org/

# workspace directory set to outer folder/directory wnds_chapter_3b
# the operating system commands in this example are Mac OS X

import scrapy  # object-oriented framework for crawling and scraping
import os  # operating system commands

# function for walking and printing directory structure
def list_all(current_directory):
    for root, dirs, files in os.walk(current_directory):
        level = root.replace(current_directory, '').count(os.sep)
        indent = ' ' * 4 * (level)
        print('{}{}/'.format(indent, os.path.basename(root)))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            print('{}{}'.format(subindent, f))

# initial directory should have this form (except for items beginning with .):
#    wnds_chapter_3c
#        run_ten_headed_spider.py
#        scrapy.cfg
#        scrapy_application/
#            __init__.py
#            items.py
#            pipelines.py
#            settings.py
#            spiders
#                __init__.py
#                ten_headed_spider.py

# examine the directory structure
current_directory = os.getcwd()
list_all(current_directory)

# list the avaliable spiders, showing names to be used for crawling
os.system('scrapy list')

# decide upon the desired format for exporting output: csv, JSON, or XML

# here we employ JSON for each of the ten sites being crawled
# we run each spider subclass separately so that stored results
# may be identified with the website being crawled

# Test crawl
os.system('scrapy crawl TEST -o results_TEST.json')

# American Medical Association
os.system('scrapy crawl AMA -o results_AMA.json')

# Harvard Medical School (Press Releases)
os.system('scrapy crawl HARVARD1 -o results_HARVARD1.json')

# Harvard Medical School (Healthy Sleep)
os.system('scrapy crawl HARVARD2 -o results_HARVARD2.json')

# Mayo Foundation for Medical Education and Research
os.system('scrapy crawl MAYO1 -o results_MAYO1.json')

# Mayo Foundation for Medical Education and Research (Napping)
os.system('scrapy crawl MAYO2 -o results_MAYO2.json')

# National Institutes of Health
os.system('scrapy crawl NIH -o results_NIH.json')

# National Sleep Foundation
os.system('scrapy crawl SLEEP -o results_SLEEP.json')

# U.S. Department of Health and Human Services (Sleep and Napping)
os.system('scrapy crawl HHS -o results_HHS.json')

# WebMD (Aging and Sleep)
os.system('scrapy crawl WEBMD -o results_WEBMD.json')

# Wikipedia (Nap)
os.system('scrapy crawl WIKINAP -o results_WIKINAP.json')

# Suggestions for the student: Use source code and element inspection
# utilities provided in modern browsers such as Firefox and Chrome
# to examine the DOM of each website being crawled/scraped. Modify the 
# scraping logic of the spider for that website as defined in the 
# def parse functions for the spider class for that website.
# Add URLs to the spider classes by adding to the start.urls attribute
# of each spider class. Ensure that each website is crawled thoroughly
# using <a> links to additional pages within the website.
# Note that some of the start.urls used in the current spiders merely
# provide links to other sources. We need to drill down into those
# sources to find journal or web articles with titles relating
# to the problem at hand: sleep, napping, and age.
# Run the focused crawl with these def parse enhancements and 
# examine the results. Repeat this process as needed.
# Use regular expressions to parse text from the final focused crawl.
# Build a text corpus for subsequent text analysis.