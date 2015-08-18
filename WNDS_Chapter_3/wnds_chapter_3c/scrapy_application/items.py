# ----------------------------
# MyItem class defined by 
# items.py
# ----------------------------
# location in directory structure:
# wnds_chapter_3c/scrapy_application/items.py

# establishes data fields for scraped items

import scrapy  # object-oriented framework for crawling and scraping

class MyItem(scrapy.item.Item):
    # define the data fields for the item (just one field used here)
    paragraph = scrapy.item.Field()  # paragraph content
