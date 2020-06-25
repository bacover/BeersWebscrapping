#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(plotly)
library(usmap)
library(rsconnect)


beerdata <- read.csv(file="./beers_3.csv")
fctr.cols <- sapply(beerdata, is.factor)
beerdata[, fctr.cols] <- sapply(beerdata[, fctr.cols], as.character)
beerdata = select(beerdata, Name=Name, Brewery=Brewery, Style=Style, ABV=ABV, Country=Country, State=State, Availability=Availability, Score=Score, Avg=Avg, Ratings=Ratings, Reviews=Reviews)
beerdata = arrange(beerdata, desc(Score))