library(shiny)
library(shinythemes)
library(wordcloud)
library(tm)
library(RColorBrewer)
library(qdap)
library(dplyr)

shinyUI(fluidPage(
    titlePanel("Word Prediction Application"),
    sidebarLayout(
        sidebarPanel(
            helpText(p(h5(HTML("<b> How the Application Works: </b> <br>
                               <ol>
                               <li> Enter a word (or a group of words) in the text box located on the right.
                               <li> A table will be generated which shows the Top 5 predicted words.")))),
            helpText(p(h5(HTML("<b><i> Note: The application only predicts until the third word. If the input is 
                               four words, it will only get the last three words to make a prediction. </b> <br>
                               Example: <br>
                               Input words are 'Where are you going' <br> 
                               the application will only read <br> 
                               'are you going' <br>
                               to create the next prediction </i>"))))
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "Word Predictor",
                    h4("Enter Text:"),
                    tags$textarea(id = 'text', placeholder = 'Type here...', rows = 3, class='form-control',""),
                    br(""),
                    h5(tableOutput('topwords'))
                ),
                
                tabPanel(
                    "About",
                    tags$div(
                        h2("Predicting the next word"),
                        tags$p("This application predicts the next word based on the last word provided.")
                    )
                )
            )
        )
    )
))