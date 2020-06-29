#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel(h1("Filterable Beers from BeerAdvocate", align = "center")),
    HTML('<center><img src="https://thisiswhyimdrunk.files.wordpress.com/2014/11/ba-on-us-map-as-jpg.jpg", width="352", height="240"></center>'),
    tags$br(),
    print("BeerAdvocate is an extensive online platform for beer styles, reviews, and scores, but sometimes the filtering available is not everything you are looking for. The following tool allows you to filter results based on a variety of factors to find your next drink easily."),
    tags$br(),
    tags$br(),
    #
    #for style see here, for review guidelines see here, etc....
    print("For more information on the styles of beer, please see here: "),
    tags$a(href="https://www.beeradvocate.com/beer/styles/", "Beer Styles"),
    tags$br(),
    print("For guidelines on how beers are scored and reviewed, please see here: "),    
    tags$a(href="https://www.beeradvocate.com/community/threads/how-to-review-a-beer.241156/", "How to Review a Beer"),
    print(" and "),
    tags$a(href="https://www.beeradvocate.com/community/threads/beeradvocate-ratings-explained.184726/", "BeerAdvocate Ratings, Explained"),
    tags$br(),
    tags$br(),
    print("Beers are listed by their score in descending order."),
    tags$br(),
    tags$br(),
    #
        br(),
    fluidRow(
        column(3,
               selectizeInput("country", "Countries:", choices = sort(unique(beerdata$Country), decreasing=FALSE), multiple=TRUE, selected="United States")
       ),
        column(3,
               selectizeInput("state", "States:", choices = sort(unique(beerdata$State), decreasing=FALSE), multiple=TRUE)
        ),
        column(3,
               selectizeInput("style", "Exclude Styles:", choices = sort(unique(beerdata$Style), decreasing=FALSE), multiple=TRUE)
        ),
        column(3,
               selectizeInput("availability", "Exclude Availabilities:", choices = unique(beerdata$Availability), multiple=TRUE)
        ),
        column(3,
               selectizeInput("brewery", "Exclude Breweries:", choices = sort(unique(beerdata$Brewery), decreasing=FALSE), multiple=TRUE)
        ),
        column(3,
               sliderInput("abv",
                           "ABV %:",
                           min = 0,
                           max = 68,
                           value = c(4,16)),
                checkboxInput("abvna", "Include Beers without reported ABV", value = FALSE)
        ),
        
        column(3,
               sliderInput("minratings",
                           "Minimum Number of Ratings:",
                           min = 0,
                           max = 100,
                           value = 10)
        ),

    ),


            tableOutput('tbl')
)
)
