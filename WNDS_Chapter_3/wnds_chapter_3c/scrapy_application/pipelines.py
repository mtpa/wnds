# ----------------------------
# MyPipeline class defined by 
# pipelines.py
# ----------------------------
# location in directory structure:
# wnds_chapter_3c/scrapy_application/pipelines.py

class MyPipeline(object):
    def process_item(self, item, spider):
        return item
