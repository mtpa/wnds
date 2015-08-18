# ----------------------------
# settings for scrapy.cfg 
# settings.py
# ----------------------------
# location in directory structure:
# wnds_chapter_3c/scrapy_application/settings.py

BOT_NAME = 'MyBot'
BOT_VERSION = '1.0'

SPIDER_MODULES = ['scrapy_application.spiders']
NEWSPIDER_MODULE = 'scrapy_application.spiders'
USER_AGENT = '%s/%s' % (BOT_NAME, BOT_VERSION)

COOKIES_ENABLED = False
DOWNLOAD_DELAY = 2  
RETRY_ENABLED = False
DOWNLOAD_TIMEOUT = 15
REDIRECT_ENABLED = False
DEPTH_LIMIT = 50


