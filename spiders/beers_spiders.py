from scrapy import Spider, Request
from beers.items import BeerItem
import re
import math


class BeerSpider(Spider):
    name = "beers_spider"
    style_num = [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40, 41, 42, 43, 46, 47, 48, 50, 52, 53, 54, 55, 56, 57, 58, 60, 66, 68, 69, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80, 82, 84, 85, 86, 87, 89, 90, 91, 92, 93, 94, 95, 97, 98, 99, 101, 114, 116, 119, 127, 128, 129, 131, 132, 141, 142, 144, 147, 148, 149, 150, 152, 154, 155, 157, 158, 159, 161, 162, 163, 164, 165, 168, 169, 171, 173, 174, 175, 189, 190, 190, 191, 192, 193, 194, 198]
#    style_num = [5, 6, 198]
    allowed_urls = ['https://www.beeradvocate.com/beer/styles/', 'https://www.beeradvocate.com/beer/profile/']
    start_urls = ['https://www.beeradvocate.com/beer/styles/' + str(i) for i in style_num]
    start_urls = [s + '/?sort=avgD&start=0' for s in start_urls]

    def parse(self, response):
        # Find the total number of pages in the result so that we can decide how many urls to scrape next

        total = re.findall('\d+', response.xpath('//tr[1]/td[@colspan="5"]/span/b/text()').extract_first())[2]

        number_pages = int(math.ceil(int(total) / 50.0))

        next_url = re.findall('"([^"]*)"', response.xpath('//tr[2]/td[@colspan="5"]/span/a[3]').extract_first())[0]
        #strip off last number
        next_url = next_url[:-13]


        # List comprehension to construct all the urls
        result_urls = [next_url + '&start=' + str(i*50) for i in range(number_pages)]
        result_urls = ['https://www.beeradvocate.com' + s for s in result_urls]
        print("First parse\n")
        for url in result_urls:
            print(url)

        # Yield the requests to different search result urls, 
        # using parse_result_page function to parse the response.
        for url in result_urls:
            yield Request(url=url, callback=self.parse_result_page)


    def parse_result_page(self, response):
        # This fucntion parses the search result page.
        
        # We are looking for url of the detail page.
        detail_urls = response.xpath('//tr/td[@class="hr_bottom_light"][1]/a/@href').extract()         

        # Yield the requests to the details pages, 
        # using parse_detail_page function to parse the response.
        print("Second parse\n")
        for url in detail_urls:
            print(url)
        for url in ['https://www.beeradvocate.com{}'.format(x) for x in detail_urls]:
            yield Request(url=url, callback=self.parse_detail_page)



    def parse_detail_page(self, response):
        # Product name
        name = response.xpath('//h1/text()').extract_first()

        # style
        beerstyle = response.xpath('//dd[@class="beerstats"]/a/b/text()').extract_first()     
        #ABV
        beerstats = response.xpath('//dd[@class="beerstats"]/span/b/text()').extract() 
        if len(beerstats) > 0:
            beerabv = beerstats[0]
            beerabv = beerabv[:-1]
            beerabv = float(beerabv)
        else:
            beerabv = ""

        #score
        if len(beerstats) >1:
            beerscore = beerstats[1]
            beerscore = int(beerscore)
        else:
            beerscore = 0

        #avg
        beeravg = response.xpath('//dd[@class="beerstats"]/b/span/text()').extract_first() 
        beeravg = float(beeravg)

        #reviews
        beerreviews = response.xpath('//dd[@class="beerstats"]/span[@class="ba-reviews Tooltip"]/text()').extract_first()  
        beerreviews = int(beerreviews.replace(',', ''))

        #ratings
        beerratings = response.xpath('//dd[@class="beerstats"]/span[@class="ba-ratings Tooltip"]/text()').extract_first()  
        beerratings = int(beerratings.replace(',', ''))

        #brewery
        beerstats = response.xpath('//dd[@class="beerstats"]/a[@class="Tooltip"]/text()').extract() 
        brewery = beerstats[-1]

        #location
        beerstats = response.xpath('//dd[@class="beerstats"]/a/text()').extract()
        country = beerstats[-1]
        if country != "United States":
            state = ""
        else:
            state = beerstats[-2]
        
        #availability
        availability = response.xpath('//dd[@class="beerstats"]/span[@class="Tooltip"]/text()').extract_first()


        item = BeerItem()
        item['Name'] = name
        item['Style'] = beerstyle
        item['Brewery'] = brewery
        item['State'] = state
        item['Country'] = country
        item['ABV'] = beerabv
        item['Score'] = beerscore
        item['Avg'] = beeravg
        item['Reviews'] = beerreviews
        item['Ratings'] = beerratings
        item['Availability'] = availability
#        print("Third parse\n")

        yield item
