library(shiny)

ngram_models <- readRDS("ngram_models.rds")
source("predict.R")

shinyServer <- function(input, output, session) {
    
    observe({
        
        predict_list <- reactive({
            inputText <- input$text
            predict_list <- predictText(inputText,ngram_models)
        })
        
        nextword <- reactive({
            inputText <- input$text
            predict_list <- predictText(inputText,ngram_models)
            nextword <- predict_list[[1]][1]
        })
        
        secondword <- reactive({
            inputText <- input$text
            predict_list <- predictText(inputText,ngram_models)
            secondword <- predict_list[[1]][2]
        })
        
        thirdword <- reactive({
            inputText <- input$text
            predict_list <- predictText(inputText,ngram_models)
            thirdword <- predict_list[[1]][3]
        })
        
        time <- reactive({
            inputText <- input$text
            predict_list <- predictText(inputText,ngram_models)
            time <- paste("Run Time: ", sprintf("%.2f", predict_list[[3]][1]), " S")
        })
        
        topwords <- reactive({
            inputText <- input$text
            predict_list <- predictText(inputText,ngram_models)
            lng <- length(predict_list[[1]])
            topwords <- data_frame("Top Words Predicted" = predict_list[[1]])
            if (lng > 6){
                lng = 6
            }
            topwords <- topwords[1:lng,]
        })
        
        output$nextword <- renderText(nextword()) 
        output$time <- renderText(time())
        output$topwords <- renderTable(topwords())
        
        output$nextword <- renderUI({
            actionButton("actionbutton1", label = nextword(), width = '32%')
        })
        output$secondword <- renderUI({
            actionButton("actionbutton2", label = secondword(), width = '32%')
        })
        output$thirdword <- renderUI({
            actionButton("actionbutton3", label = thirdword(), width = '32%')
        })
        
        observeEvent(input$actionbutton1, {
            if(input$actionbutton1 == 1){
                newtext <- paste(input$text, nextword())
                updateTextInput(session, "text", value=newtext)
            }
        })
        
        observeEvent(input$actionbutton2, {
            newtext <- paste(input$text, secondword())
            updateTextInput(session, "text", value=newtext)
        })
        
        observeEvent(input$actionbutton3, {
            newtext <- paste(input$text, thirdword())
            updateTextInput(session, "text", value=newtext)
        })
        
        wordcloud_rep <- repeatable(wordcloud)
        colbrew <- brewer.pal(8, "Set2")
        
        output$wordcloud <- renderPlot(
            wordcloud_rep(
                predict_list()[[1]],
                predict_list()[[2]],
                colors=colbrew[c(1:11)],
                max.words=30,
                scale=c(5,0.75),
                min.freq = 0
            )
        )
    })
}
