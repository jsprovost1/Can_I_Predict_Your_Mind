
# Importing the libraries
library(shiny)

# Sourcing the prediction function
source("predict_words.R")
source("probability_words.R")

# Extracting the correct prediction and outputing the answer
shinyServer(function(input, output) {
    
  answer <- reactive(predict_words(input$text, input$sliderDiscount, input$num_alternatives))
  output$text1 = renderText(input$text)
  output$predictions <- renderTable(answer())

  
  answer2 <- reactive(probability_words(input$text2))
  output$probability <- renderTable(answer2())
})
  
