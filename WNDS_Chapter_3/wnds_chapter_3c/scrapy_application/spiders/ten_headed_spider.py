# ----------------------------
# spider class defined by 
# script ten_headed_spider.py
# ----------------------------
# location in directory structure:
# wnds_chapter_3c/scrapy_application/spiders/ten_headed_spider.py

# prepare for Python version 3x features and functions
from __future__ import division, print_function

# each spider class gives code for crawing and scraping

import scrapy  # object-oriented framework for crawling and scraping
from scrapy_application.items import MyItem  # item class 

# each spider subclass inherits from BaseSpider
# each spider subclass is designed to crawl one website
# each spider can have its own parsing logic based on the 
# DOM of the website being crawled snd scraped... 

class MySpiderTEST(scrapy.spider.BaseSpider):
    name = "TEST"  # unique identifier for the spider
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


# American Medical Association
class MySpiderAMA(scrapy.spider.BaseSpider):
    name = "AMA"  # unique identifier for the spider
    # limit the crawl to this domain list
    allowed_domains = ['ama-assn.org']  
    # first url to crawl in domain
    start_urls = ['http://jama.jamanetwork.com/solr/searchresults.aspx?q=sleep&fd_JournalID=67&f_JournalDisplayName=JAMA&SearchSourceType=3']  
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


# Harvard Medical School (Press Releases)
class MySpiderHARVARD1(scrapy.spider.BaseSpider):
    name = "HARVARD1"  # unique identifier for the spider
    allowed_domains = ['health.harvard.edu']  # limits the crawl to this domain list
    # first url to crawl in domain
    start_urls = ['http://www.health.harvard.edu/press_releases/snoozing-without-guilt--a-daytime-nap-can-be-good-for-health']
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


# Harvard Medical School (Healthy Sleep)
class MySpiderHARVARD2(scrapy.spider.BaseSpider):
    name = "HARVARD2"  # unique identifier for the spider
    allowed_domains = ['med.harvard.edu']  # limits the crawl to this domain list
    # first url to crawl in domain
    start_urls = ['http://healthysleep.med.harvard.edu/healthy/science/variations/changes-in-sleep-with-age']
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
        
        
# Mayo Foundation for Medical Education and Research
class MySpiderMAYO1(scrapy.spider.BaseSpider):
    name = "MAYO1"  # unique identifier for the spider
    # limit the crawl to this domain list
    allowed_domains = ['mayoclinic.org']  
    # first url to crawl in domain
    start_urls = ['http://www.mayoclinic.org']  
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


# Mayo Foundation for Medical Education and Research (Napping)
class MySpiderMAYO2(scrapy.spider.BaseSpider):
    name = "MAYO2"  # unique identifier for the spider
    # limit the crawl to this domain list
    allowed_domains = ['mayoclinic.org']  
    # first url to crawl in domain
    start_urls = ['http://www.mayoclinic.org/napping/ART-20048319?p=1']  
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


# National Institutes of Health
class MySpiderNIH(scrapy.spider.BaseSpider):
    name = "NIH"  # unique identifier for the spider
    allowed_domains = ['nih.gov']  # limits the crawl to this domain list
    start_urls = ['http://nih.gov']  # first url to crawl in domain
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


# National Sleep Foundation
class MySpiderSLEEP(scrapy.spider.BaseSpider):
    name = "SLEEP"  # unique identifier for the spider
    # limit the crawl to this domain list
    allowed_domains = ['sleepfoundation.org']  
    # first url to crawl in domain
    start_urls = ['http://sleepfoundation.org/sleep-topics/napping']  
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




# U.S. Department of Health and Human Services (Sleep and Napping)
class MySpiderHHS(scrapy.spider.BaseSpider):
    name = "HHS"  # unique identifier for the spider
    # limit the crawl to this domain list
    allowed_domains = ['healthfinder.gov']  
    # first url to crawl in domain
    start_urls = ['http://healthfinder.gov/search/?q=sleep+and+napping']  
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


# WebMD (Aging and Sleep)
class MySpiderWEBMD(scrapy.spider.BaseSpider):
    name = "WEBMD"  # unique identifier for the spider
    # limit the crawl to this domain list
    allowed_domains = ['webmd.com']  
    # first url to crawl in domain
    start_urls =\
        ['http://www.webmd.com/sleep-disorders/guide/aging-affects-sleep']  
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


# Wikipedia (Nap)
class MySpiderWIKINAP(scrapy.spider.BaseSpider):
    name = "WIKINAP"  # unique identifier for the spider
    allowed_domains = ['wikipedia.org']  # limits the crawl to this domain list
    # first url to crawl in domain
    start_urls = ['http://en.wikipedia.org/wiki/Nap']  
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
                                 