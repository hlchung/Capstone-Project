library(shiny)
library(shinythemes)
library(wordcloud)
library(tm)
library(RColorBrewer)
library(qdap)
library(dplyr)

shinyUI <- (fluidPage(
    titlePanel("Word Prediction App"),
    sidebarLayout(
        sidebarPanel(
            tags$head(
                tags$style(HTML("
                                    #actionbutton1, #actionbutton2, #actionbutton3{
                                    color: #FFFFFF;
                                    font-weight: bold;
                                    background-color: #000080
                                    }
                                   ")) 
            ),
            tags$div(
                tags$link(rel = "stylesheet", type = "text/css", href = "idx.css"),
                h4("Enter Text"),
                tags$textarea(id = 'text', placeholder = 'Type here...', rows = 3, class='form-control',"")),
            h5("Select Next Word..."),
            htmlOutput("nextword",inline = T),
            htmlOutput("secondword",inline = T),
            htmlOutput("thirdword",inline = T),
            br(" "),
            h5(tableOutput('topwords'))),
        
        mainPanel(
            tabsetPanel(
                id = "tabPanel",
                tabPanel("Word Cloud",
                         tags$div(
                             h2("Wordcloud", align = "Center",
                                style = "color: #000080; font-weight: bold;")),
                         tags$div(
                             plotOutput('wordcloud')
                         )
                ),
                tabPanel("Guide",
                         tags$div(
                             h2("Predicting the next word"),
                             tags$p("This application predicts the next word based on the last word provided. The algorithm used in this application follows the same pattern from three sample compilations of English texts drawn from Blogs, News, and Twitter.  The data file can be downloaded here: https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"),
                             tags$hr(),
                             tags$div(
                                 h4("How do I use the app?"),
                                 tags$p("1. Enter a word (or a group of words) in the text box located at the upperleft of the screen OR select from the suggested words below the text box."),
                                 tags$p("2. Wait for the list and wordcloud to generate results. The list displays the top 6 predicted words while the wordcloud displays the top 30. The bigger the text, the more likely it will preceed the last word entered in the text box. You may see different results with different word combinations!"))
                         )
                )),
            hr(),
            tags$span(style="color:black", 
                      tags$footer("Word Prediction App 2019", 
                                  align = "Center"))
        )
    )
))