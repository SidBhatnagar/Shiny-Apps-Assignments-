library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Assignment 4"),
  
  tabsetPanel(
    tabPanel("Data",
             verbatimTextOutput("DataSummary"),
             plotOutput("BoxPlots"),
             DT::dataTableOutput("Table")
    ),
    tabPanel("Split",
            sliderInput("Split", "Train proportion", min = 0, max=1, value = 0.8),
             verbatimTextOutput("SplitSummary")
    ),
    tabPanel("GLMnet Model",
             tags$h3("Best tuning parameters:"),
             tableOutput("GlmModelSummary1"),
             hr(),
             plotOutput("GlmModelPlots"),
             verbatimTextOutput("GlmModelSummary2")
    ),
    tabPanel("PLS Model",
             tags$h3("Best tuning parameters:"),
             tableOutput("PlsModelSummary1"),
             hr(),
             plotOutput("PlsModelPlots"),
             verbatimTextOutput("PlsModelSummary2")
    ),
    tabPanel("ANN Model",
             tags$h3("Best tuning parameters:"),
             tableOutput("AnnModelSummary1"),
             hr(),
             plotOutput("AnnModelPlots"),
             verbatimTextOutput("AnnModelSummary2")
    ),
    tabPanel("XGB Model",
             tags$h3("Best tuning parameters:"),
             tableOutput("XGBSummary1"),
             hr(),
             plotOutput("XGBPlots"),
             verbatimTextOutput("XGBSummary2")
            
    ),
             
    tabPanel("SVM Model",
             tags$h3("Best tuning parameters:"),
             tableOutput("SVMSummary1"),
             hr(),
             plotOutput("SVMPlots"),
             verbatimTextOutput("SVMSummary2")
             
    ),    
    
    tabPanel("RPart Model",
             tags$h3("Best tuning parameters:"),
             tableOutput("RPartSummary1"),
             hr(),
             plotOutput("RPartPlots"),
             verbatimTextOutput("RPartSummary2")
    ),
    tabPanel("Model Selection",
             tags$h3("Cross validation results:"),
             checkboxInput("Notch", "Show notch", value = FALSE),
             plotOutput("SelectionBoxPlot"),
             radioButtons("Choice", "Model choice", choices = c("GLMnet", "PLS", "ANN", "XGB","SVM","RP"), selected = "PLS")
    ),
    tabPanel("Performance",
             htmlOutput("Title"),
             verbatimTextOutput("TestSummary"),
             plotOutput("TestPlot")
    )
  )
))
