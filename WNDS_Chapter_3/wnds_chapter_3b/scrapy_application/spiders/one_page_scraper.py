# ----------------------------
# spider class defined by 
# script one_page_scraper.py
# ----------------------------
# location in directory structure:
# wnds_chapter_3b/scrapy_application/spiders/one_page_scraper.py

# prepare for Python version 3x features and functions
from __future__ import division, print_function

# each spider class gives code for crawing and scraping

import scrapy  # object-oriented framework for crawling and scraping
from scrapy_application.items import MyItem  # item class 

# spider subclass inherits from BaseSpider
# this spider is designed to crawl just one page of one website
class MySpider(scrapy.spider.BaseSpider):
    name = "TOUTBAY"  # unique identifier for the spider
    allowed_domains = ['toutbay.com']  # limits the crawl to this domain list
    start_urls = ['http://www.toutbay.com']  # first url to crawl in domain
       
    # define the parsing method for the spider
    def parse(self, response):
        html_scraper = scrapy.selector.HtmlXPathSelector(response)
        divs = html_scraper.select('//div')  # identify all <div> nodes
        # XPath syntax to grab all the text in paragraphs in the <div> nodes
        results = []  # initialize list
        this_item = MyItem()  # use this item class
        this_item['paragraph'] = divs.select('.//p').extract()  
        results.append(this_item)  # add to the results list
        return results 
        

   