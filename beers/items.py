# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class BeerItem(scrapy.Item):
    # define the fields for your item here like:

    Name = scrapy.Field()
    Brewery = scrapy.Field()
    Style = scrapy.Field()
    State = scrapy.Field()
    Country = scrapy.Field()
    ABV = scrapy.Field()
    Score = scrapy.Field()
    Avg = scrapy.Field()
    Reviews = scrapy.Field()
    Ratings = scrapy.Field()
    Availability = scrapy.Field()

