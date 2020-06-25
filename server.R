#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(rlang)
library(reshape2)
library(withr)
library(plotly)
library(usmap)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    observe({
        countrybeerdata = filter(beerdata, !Style %in% input$style)
        countrybeerdata = filter(countrybeerdata, !Availability %in% input$availability)
        countrybeerdata = filter(countrybeerdata, !Brewery %in% input$brewery)
        if (input$abvna)
        {
            countrybeerdata = filter(countrybeerdata, ((ABV > input$abv[1]) & (ABV < input$abv[2])) | is.na(ABV))
        } else {
            countrybeerdata = filter(countrybeerdata, (ABV > input$abv[1]) & (ABV < input$abv[2]))
        }
        countrybeerdata = filter(countrybeerdata, Ratings >= input$minratings)
        updateSelectizeInput(
            session, "country",
            choices = sort(unique(countrybeerdata$Country), decreasing=FALSE),
            selected=input$country)
        if (length(input$country) !=0)
        {
            countrybeerdata = filter(countrybeerdata, Country %in% input$country)
        }
        updateSelectizeInput(
            session, "state",
            choices = sort(unique(countrybeerdata$State), decreasing=FALSE),
            selected=input$state)
        
        
        stylebeerdata = filter(beerdata, Ratings >= input$minratings)        
        if (length(input$country) !=0)
        {
            stylebeerdata = filter(stylebeerdata, Country %in% input$country)
        }
        if (length(input$state) !=0)
        {
            stylebeerdata = filter(stylebeerdata, State %in% input$state)
        }            
        stylebeerdata = filter(stylebeerdata, !Availability %in% input$availability)
        stylebeerdata = filter(stylebeerdata, !Brewery %in% input$brewery)
        if (input$abvna)
        {
            stylebeerdata = filter(stylebeerdata, ((ABV > input$abv[1]) & (ABV < input$abv[2])) | is.na(ABV))
        } else {
            stylebeerdata = filter(stylebeerdata, (ABV > input$abv[1]) & (ABV < input$abv[2]))
        }
        updateSelectizeInput(
            session, "style",
            choices = sort(unique(stylebeerdata$Style), decreasing=FALSE),
            selected=input$style)
        
        
        availbeerdata = filter(beerdata, Ratings >= input$minratings)
        if (length(input$country) !=0)
        {
            availbeerdata = filter(availbeerdata, Country %in% input$country)
        }
        if (length(input$state) !=0)
        {
            availbeerdata = filter(availbeerdata, State %in% input$state)
        }            
        availbeerdata = filter(availbeerdata, !Style %in% input$style)
        availbeerdata = filter(availbeerdata, !Brewery %in% input$brewery)
        if (input$abvna)
        {
            availbeerdata = filter(availbeerdata, ((ABV > input$abv[1]) & (ABV < input$abv[2])) | is.na(ABV))
        } else {
            availbeerdata = filter(availbeerdata, (ABV > input$abv[1]) & (ABV < input$abv[2]))
        }
        updateSelectizeInput(
            session, "availability",
            choices = unique(availbeerdata$Availability),
            selected=input$availability)

        brewerybeerdata = filter(beerdata, Ratings >= input$minratings)
        if (length(input$country) !=0)
        {
            brewerybeerdata = filter(brewerybeerdata, Country %in% input$country)
        }
        if (length(input$state) !=0)
        {
            brewerybeerdata = filter(brewerybeerdata, State %in% input$state)
        }            
        brewerybeerdata = filter(brewerybeerdata, !Style %in% input$style)
        brewerybeerdata = filter(brewerybeerdata, !Availability %in% input$availability)
        if (input$abvna)
        {
            brewerybeerdata = filter(brewerybeerdata, ((ABV > input$abv[1]) & (ABV < input$abv[2])) | is.na(ABV))
        } else {
            brewerybeerdata = filter(brewerybeerdata, (ABV > input$abv[1]) & (ABV < input$abv[2]))
        }

        updateSelectizeInput(
            session, "brewery", 
            choices = sort(unique(brewerybeerdata$Brewery), decreasing=FALSE),
            selected=input$brewery)
        
    })
    
    output$tbl <- renderTable({
        if (length(input$country) !=0)
        {
            beerdata = filter(beerdata, Country %in% input$country)
        }
        if (length(input$state) !=0)
        {
            beerdata = filter(beerdata, State %in% input$state)
        }            
        beerdata = filter(beerdata, !Style %in% input$style)
        beerdata = filter(beerdata, !Availability %in% input$availability)
        beerdata = filter(beerdata, !Brewery %in% input$brewery)
        if (input$abvna)
        {
            beerdata = filter(beerdata, ((ABV > input$abv[1]) & (ABV < input$abv[2])) | is.na(ABV))
        } else {
            beerdata = filter(beerdata, (ABV > input$abv[1]) & (ABV < input$abv[2]))
        }
        beerdata = filter(beerdata, Ratings >= input$minratings)
        beerdata
        },  
                              striped = TRUE, bordered = TRUE,  
                              hover = TRUE, spacing = 'xs',  
                              na = 'missing') 

    
    
    
})
