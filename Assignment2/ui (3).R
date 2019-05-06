
library(shiny)
library(shinyjs)

shinyUI(fluidPage(
  useShinyjs(),
  titlePanel("Dimensional Reduction"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Method", label = "Method", choices = c("simpls","kernelpls","widekernelpls","oscorespls"), selected="simpls"),
      selectInput("valid",label="Validate",choices = c("LOO","none","CV"),selected ="CV"),
      sliderInput("Components", label ="Components:", min = 1, max = 10, value = 3),
      selectInput("noise","Noisiness of the data:",
                  list("Low","Medium","High"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("PLS", plotOutput("PLSR",width = "100%", height = "400px")),
        tabPanel("Correlation",plotOutput("corr",width = "100%", height = "400px")),
        tabPanel("Score",plotOutput("scores",width = "100%", height = "400px")),
        tabPanel("Load",plotOutput("loadings",width = "100%", height = "400px"))
        
      ) 
    )
  )
)
)
