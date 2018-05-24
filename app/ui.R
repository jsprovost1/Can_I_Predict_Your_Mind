
# Importing the libraries
library(shiny)

# Define UI for application
shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Last Word Prediction", fluid = TRUE,
             sidebarLayout(
                sidebarPanel(
                      textInput(inputId = "text", label= "Please Enter Your Trigram For Prediction:"),
                      sliderInput(inputId ="sliderDiscount", "Please Select Your Discounting Parameter", min = 0, max = 1, value=0.5, step = 0.05),
                      sliderInput(inputId = "num_alternatives", label = "Number Of Alternative Possibilities (Enter a value other then 0)", min = 0, max = 20, step = 1, value = 2),
                      submitButton("Predict!")),
                mainPanel(fluidRow( 
                  tabPanel("Last Word Prediction",
                           h3("Trigram Being Processed"),
                           tags$i("Please acknowledge that the first query might take longer to be processed"),
                           textOutput("text1"),
                           tableOutput("predictions")
                    )
                  
                ))
            )
    ),
    tabPanel("Probability Prediction", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 textInput(inputId = "text2", label= "Please Enter Your Fourgram:"),
                 submitButton("Give Me the Probability!")),
               mainPanel(fluidRow(
                 tabPanel("Probability Prediction", h3("Fourgram Being Processed"), tableOutput("probability"),
                          tags$i("(Please acknowledge that the first query might take up to 3 minutes for initialization. However the following queries will be processed instantaneously. Sorry for the inconvenience, I am working hard on optimizing this product)")
               ))
                )
             )
              )
             )
  ))


