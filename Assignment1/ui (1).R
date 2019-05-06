#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)


shinyUI(
  
  # Application title
  fluidPage(
    useShinyjs(),
    titlePanel("Boot:urine, Analysis conducted to determine physical urinary characteristics in the formation of calcium oxalate crystals.By Sidhartha Bhatnagar"),
    tabsetPanel(
      
      tabPanel("Table", 
               tableOutput("table")), 
      
      tabPanel("Summary",
               verbatimTextOutput("DataSummary"), 
               tags$b("Here is my interpretation of the summary data."),
               plotOutput("rPlot"),
               checkboxInput("outliers", "Show outliers", FALSE)
      ),
      
      tabPanel("Correlation Plot", 
               plotOutput("checktwo"),
               tags$b("The above correlation determines the relationship between the obtained results 
                       contributing towards a positive result. for example, a strong relationship between 
                       the gravity, osmo and urea are present in a positive result.")
      ),
      
      tabPanel("Scatter Plot",
               
               selectInput(
                 "var",
                 label = "Choose the y variable",
                 choices = c("Specific gravity",
                             "Osmolarity",
                             "Conductivity",
                             "Urea",
                             "Calcium"),
                 selected = "ph"),
               
               selectInput(
                 "vars",
                 label = "Choose the x variable",
                 choices = c("Specific gravity",
                             "Osmolarity",
                             "Conductivity",
                             "Urea",
                             "Calcium"),
                 selected = "ph"),
               
               plotOutput("Checkone"),
               tags$b("The above scatterplot shows the correlation between the x and y variables. 
                      The R value shows the reactivity (positive or negative). From the scatterplot,
                      it can be inferred that, when certain values are high and the correlation is strong,
                      the chances of the patient having a calcium crystal increases.0 is shown as negative and 1 as positive.The description of the dataset selected to create the shiny app,can be described as being a compilation of various,
                      laboratory urine test samples to determine which patients had tested positive or negative to having calcium oxalate crystals. 
                      The document contained between two to three N/A values which were omitted using the data command na.omit. this allowed for a clear representation of other,
                      values. The summary output was generated to give different values, and a boxplot was made without the R value as it is a factor.
                      To show the relationship between the variables ggplot was used to construct the corrgram to show the correlation between the variables. overall, it can be determined that with a few outliers the majority of the data is 
                      within sensible data value. Standard deviation and hypothesis testing can also be done to better understand the results. 
                      To conclude, the relationship between the variables reflects a positive correlation between a positive test and the gravity, urea and osmo.  
                      ")
               
      )
    )
  )
)




